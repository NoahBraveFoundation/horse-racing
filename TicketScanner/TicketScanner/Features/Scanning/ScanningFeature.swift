import ComposableArchitecture
import Dependencies

@Reducer
struct ScanningFeature {
    @ObservableState
    struct State: Equatable {
        var isScanning = false
        var lastScanResult: ScanResult?
        var errorMessage: String?
        var isShowingResult = false
        var currentScanner: User?
        var scanningStats: ScanningStats?
        var recentScans: [TicketScan] = []
    }
    
    enum Action: Equatable {
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
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startScanning:
                state.isScanning = true
                state.errorMessage = nil
                return .run { send in
                    await barcodeScanner.startScanning { barcode in
                        await send(.barcodeScanned(barcode))
                    }
                }
                
            case .stopScanning:
                state.isScanning = false
                return .run { _ in
                    await barcodeScanner.stopScanning()
                }
                
            case let .barcodeScanned(barcode):
                state.isScanning = false
                return .run { send in
                    let location = await locationService.currentLocation()
                    let deviceInfo = await getDeviceInfo()
                    
                    await send(.scanTicketResponse(
                        await TaskResult {
                            try await apiClient.scanTicket(barcode, location, deviceInfo)
                        }
                    ))
                }
                
            case let .scanTicketResponse(.success(response)):
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
                        await barcodeScanner.stopScanning()
                    },
                    .send(.loadStats),
                    .send(.loadRecentScans)
                )
                
            case let .scanTicketResponse(.failure(error)):
                state.errorMessage = error.localizedDescription
                return .run { _ in
                    await barcodeScanner.stopScanning()
                }
                
            case .dismissResult:
                state.isShowingResult = false
                state.lastScanResult = nil
                return .none
                
            case .clearError:
                state.errorMessage = nil
                return .none
                
            case let .setCurrentScanner(scanner):
                state.currentScanner = scanner
                return .none
                
            case .loadStats:
                return .run { send in
                    await send(.statsResponse(
                        await TaskResult {
                            try await apiClient.getScanningStats()
                        }
                    ))
                }
                
            case let .statsResponse(.success(stats)):
                state.scanningStats = stats
                return .none
                
            case let .statsResponse(.failure(error)):
                state.errorMessage = error.localizedDescription
                return .none
                
            case .loadRecentScans:
                return .run { send in
                    await send(.recentScansResponse(
                        await TaskResult {
                            try await apiClient.getRecentScans(10)
                        }
                    ))
                }
                
            case let .recentScansResponse(.success(scans)):
                state.recentScans = scans
                return .none
                
            case let .recentScansResponse(.failure(error)):
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
    
    private func getDeviceInfo() async -> String {
        let device = UIDevice.current
        return "\(device.model) - \(device.systemName) \(device.systemVersion)"
    }
}

