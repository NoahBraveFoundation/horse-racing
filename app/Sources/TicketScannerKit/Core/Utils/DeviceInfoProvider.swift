#if canImport(UIKit)
  import UIKit
#endif

enum DeviceInfoProvider {
  @MainActor static func currentDescription() -> String {
    #if canImport(UIKit)
      let device = UIDevice.current
      return "\(device.model) - \(device.systemName) \(device.systemVersion)"
    #else
      return "Unknown Device"
    #endif
  }
}
