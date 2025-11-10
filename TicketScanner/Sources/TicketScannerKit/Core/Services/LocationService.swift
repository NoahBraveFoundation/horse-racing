import CoreLocation
import Dependencies
import Foundation

struct LocationService {
  var currentLocation: @Sendable () async -> String?
  var requestAuthorization: @Sendable () async -> Bool
}

extension LocationService: DependencyKey {
  static let liveValue: LocationService = {
    let manager = LocationManager()
    return LocationService(
      currentLocation: {
        await manager.getCurrentLocationName()
      },
      requestAuthorization: {
        await manager.requestAuthorization()
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
    guard await requestAuthorization() else {
      return nil
    }

    guard let location = await getCurrentLocation() else {
      return nil
    }

    return await reverseGeocode(location)
  }

  private func getCurrentLocation() async -> CLLocation? {
    await withCheckedContinuation { continuation in
      self.continuation = continuation
      manager.requestLocation()
    }
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
