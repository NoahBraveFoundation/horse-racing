import Dependencies
import Foundation
import Sharing

struct LocationService {
  static let defaultLocationName = "Tina's Tavern"

  var currentLocation: @Sendable () async -> String
}

extension LocationService: DependencyKey {
  static let liveValue: LocationService = {
    @MainActor
    final class LocationPreference {
      static let shared = LocationPreference()

      @SharedReader(.appStorage(SharedStorageKey.preferredLocationName))
      private var storedName: String = LocationService.defaultLocationName

      func currentName() -> String {
        let trimmed = storedName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? LocationService.defaultLocationName : trimmed
      }
    }

    return LocationService(
      currentLocation: {
        await MainActor.run {
          LocationPreference.shared.currentName()
        }
      }
    )
  }()

  static let testValue = LocationService(
    currentLocation: {
      defaultLocationName
    }
  )

  static let previewValue = LocationService(
    currentLocation: {
      defaultLocationName
    }
  )
}

extension DependencyValues {
  var locationService: LocationService {
    get { self[LocationService.self] }
    set { self[LocationService.self] = newValue }
  }
}
