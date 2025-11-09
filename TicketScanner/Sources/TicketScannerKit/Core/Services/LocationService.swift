import CoreLocation
import Dependencies
import Foundation

struct LocationService {
  var currentLocation: @Sendable () async -> String?
  var requestAuthorization: @Sendable () async -> Bool
}

extension LocationService: DependencyKey {
  static let liveValue = LocationService(
    currentLocation: {
      // In a real implementation, this would get the actual location
      // For now, return a placeholder
      return "Main Entrance"
    },
    requestAuthorization: {
      // In a real implementation, this would request location permissions
      return true
    }
  )
}

extension DependencyValues {
  var locationService: LocationService {
    get { self[LocationService.self] }
    set { self[LocationService.self] = newValue }
  }
}
