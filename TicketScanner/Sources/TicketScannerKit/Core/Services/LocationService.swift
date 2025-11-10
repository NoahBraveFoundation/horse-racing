import CoreLocation
import Dependencies
import Foundation

struct LocationService {
  var currentLocation: @Sendable () async -> String?
  var requestAuthorization: @Sendable () async -> Bool
  var preWarm: @Sendable () async -> Void
}

extension LocationService: DependencyKey {
  static let liveValue: LocationService = {
    @MainActor
    final class ManagerHolder {
      static let shared = ManagerHolder()
      let manager = LocationManager()
      private init() {}
    }

    return LocationService(
      currentLocation: {
        await ManagerHolder.shared.manager.getCurrentLocationName()
      },
      requestAuthorization: {
        await ManagerHolder.shared.manager.requestAuthorization()
      },
      preWarm: {
        await ManagerHolder.shared.manager.preWarmLocation()
      }
    )
  }()
}

extension DependencyValues {
  var locationService: LocationService {
    get { self[LocationService.self] }
    set { self[LocationService.self] = newValue }
  }
}

// MARK: - Location Manager

@MainActor
private final class LocationManager: NSObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private var continuation: CheckedContinuation<CLLocation?, Never>?
  private var authContinuation: CheckedContinuation<Bool, Never>?
  private var cachedLocation: CLLocation?
  private var cachedLocationName: String?
  private var cachedTimestamp: Date?
  private let cacheTTL: TimeInterval = 60 * 10
  private let cacheDistanceThreshold: CLLocationDistance = 25
  private var refreshTask: Task<Void, Never>?

  override init() {
    super.init()
    manager.delegate = self
  }

  func requestAuthorization() async -> Bool {
    let status = manager.authorizationStatus

    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      return true
    case .notDetermined:
      return await withCheckedContinuation { continuation in
        self.authContinuation = continuation
        manager.requestWhenInUseAuthorization()
      }
    default:
      return false
    }
  }

  func getCurrentLocationName() async -> String? {
    if let cachedName = cachedLocationName, let timestamp = cachedTimestamp {
      let age = Date().timeIntervalSince(timestamp)
      if age < cacheTTL {
        return cachedName
      }
      if refreshTask == nil {
        scheduleRefresh()
      }
      return cachedName
    }

    return await refreshLocation()
  }

  private func getCurrentLocation() async -> CLLocation? {
    await withCheckedContinuation { continuation in
      // Resume any in-flight request to avoid leaking continuations if callers re-enter
      if let pending = self.continuation {
        pending.resume(returning: nil)
      }

      guard CLLocationManager.locationServicesEnabled() else {
        continuation.resume(returning: nil)
        return
      }

      self.continuation = continuation
      manager.requestLocation()
    }
  }

  private func refreshLocation() async -> String? {
    guard await requestAuthorization() else {
      return cachedLocationName
    }

    guard let location = await getCurrentLocation() else {
      return cachedLocationName
    }

    if let cachedLocation, let cachedName = cachedLocationName,
      location.distance(from: cachedLocation) < cacheDistanceThreshold
    {
      cachedTimestamp = Date()
      return cachedName
    }

    guard let name = await reverseGeocode(location) else {
      return cachedLocationName
    }

    cachedLocation = location
    cachedLocationName = name
    cachedTimestamp = Date()
    return name
  }

  private func scheduleRefresh() {
    refreshTask?.cancel()
    refreshTask = Task { @MainActor [weak self] in
      guard let self else { return }
      defer { self.refreshTask = nil }
      _ = await self.refreshLocation()
    }
  }

  func preWarmLocation() async {
    if cachedLocationName != nil {
      return
    }
    _ = await refreshLocation()
  }

  private func reverseGeocode(_ location: CLLocation) async -> String? {
    let geocoder = CLGeocoder()

    do {
      let placemarks = try await geocoder.reverseGeocodeLocation(location)
      guard let placemark = placemarks.first else { return nil }

      // Build a descriptive name from the placemark
      var components: [String] = []

      if let name = placemark.name {
        components.append(name)
      } else if let thoroughfare = placemark.thoroughfare {
        components.append(thoroughfare)
      }

      if let locality = placemark.locality {
        components.append(locality)
      }

      return components.isEmpty ? nil : components.joined(separator: ", ")
    } catch {
      return nil
    }
  }

  nonisolated func locationManager(
    _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
  ) {
    Task { @MainActor in
      continuation?.resume(returning: locations.first)
      continuation = nil
    }
  }

  nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    Task { @MainActor in
      continuation?.resume(returning: nil)
      continuation = nil
    }
  }

  nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    Task { @MainActor in
      let authorized = status == .authorizedWhenInUse || status == .authorizedAlways
      authContinuation?.resume(returning: authorized)
      authContinuation = nil
    }
  }
}
