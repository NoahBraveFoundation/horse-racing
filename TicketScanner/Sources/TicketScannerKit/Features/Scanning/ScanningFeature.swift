import ComposableArchitecture
import Dependencies
import UIKit

@Reducer
public struct ScanningFeature {
  @ObservableState
  public struct State: Equatable {
    public var isScanning = false
    public var lastScanResult: ScanResult?
    public var errorMessage: String?
    public var isShowingResult = false
    public var currentScanner: User?
    public var scanningStats: ScanningStats?
    public var recentScans: [TicketScan] = []

    public init() {}
  }

  public enum Action: Equatable {
    case startScanning
    case stopScanning
    case barcodeScanned(String)
    case scanTicketResponse(TaskResult<ScanTicketResponse>)
    case dismissResult
    case clearError
    case setCurrentScanner(User)
    case loadStats
    case statsResponse(TaskResult<ScanningStats>)
    case loadRecentScans
    case recentScansResponse(TaskResult<[TicketScan]>)
  }

  @Dependency(\.barcodeScanner) var barcodeScanner
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.locationService) var locationService

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startScanning:
        state.isScanning = true
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.barcodeScanner) var barcodeScanner
          await barcodeScanner.startScanning { barcode in
            await send(.barcodeScanned(barcode))
          }
        }

      case .stopScanning:
        state.isScanning = false
        return .run { _ in
          @Dependency(\.barcodeScanner) var barcodeScanner
          await barcodeScanner.stopScanning()
        }

      case .barcodeScanned(let barcode):
        state.isScanning = false
        return .run { send in
          @Dependency(\.locationService) var locationService
          @Dependency(\.apiClient) var apiClient
          let location = await locationService.currentLocation()
          let deviceInfo = await getDeviceInfo()

          await send(
            .scanTicketResponse(
              await TaskResult {
                try await apiClient.scanTicket(barcode, location, deviceInfo)
              }
            ))
        }

      case .scanTicketResponse(.success(let response)):
        state.lastScanResult = ScanResult(
          success: response.success,
          message: response.message,
          ticket: response.ticket,
          alreadyScanned: response.alreadyScanned,
          previousScan: response.previousScan
        )
        state.isShowingResult = true

        // Reload stats and recent scans after successful scan
        return .concatenate(
          .run { _ in
            @Dependency(\.barcodeScanner) var barcodeScanner
            await barcodeScanner.stopScanning()
          },
          .send(.loadStats),
          .send(.loadRecentScans)
        )

      case .scanTicketResponse(.failure(let error)):
        state.errorMessage = error.localizedDescription
        return .run { _ in
          @Dependency(\.barcodeScanner) var barcodeScanner
          await barcodeScanner.stopScanning()
        }

      case .dismissResult:
        state.isShowingResult = false
        state.lastScanResult = nil
        return .none

      case .clearError:
        state.errorMessage = nil
        return .none

      case .setCurrentScanner(let scanner):
        state.currentScanner = scanner
        return .none

      case .loadStats:
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .statsResponse(
              await TaskResult {
                try await apiClient.getScanningStats()
              }
            ))
        }

      case .statsResponse(.success(let stats)):
        state.scanningStats = stats
        return .none

      case .statsResponse(.failure(let error)):
        state.errorMessage = error.localizedDescription
        return .none

      case .loadRecentScans:
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .recentScansResponse(
              await TaskResult {
                try await apiClient.getRecentScans(10)
              }
            ))
        }

      case .recentScansResponse(.success(let scans)):
        state.recentScans = scans
        return .none

      case .recentScansResponse(.failure(let error)):
        state.errorMessage = error.localizedDescription
        return .none
      }
    }
  }
}

@MainActor
private func getDeviceInfo() async -> String {
  let device = UIDevice.current
  return "\(device.model) - \(device.systemName) \(device.systemVersion)"
}
