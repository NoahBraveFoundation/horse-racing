import ComposableArchitecture
import Foundation
import Sharing

@Reducer
public struct StatsFeature {
  public enum RefreshTrigger: Equatable {
    case initial
    case userInitiated
    case scanUpdate
  }

  @ObservableState
  public struct State: Equatable {
    @Shared(.appStorage(SharedStorageKey.scanningStats))
    public var scanningStats: ScanningStats? = nil
    @Shared(.appStorage(SharedStorageKey.recentScans))
    public var recentScans: [TicketScan] = []
    public var isLoading = false
    public var errorMessage: String?
    public var hasLoaded = false

    public init() {}
  }

  public enum Action: Equatable {
    case onAppear
    case refresh(RefreshTrigger)
    case refreshResponse(TaskResult<ScanningStats>)
    case clearError
  }

  @Dependency(\.apiClient) var apiClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        if state.hasLoaded {
          return .none
        }
        return .send(.refresh(.initial))

      case .refresh(let trigger):
        if trigger != .scanUpdate {
          state.isLoading = true
        }
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .refreshResponse(
              await TaskResult {
                try await apiClient.getScanningStats()
              }
            ))
        }

      case .refreshResponse(.success(let stats)):
        state.isLoading = false
        state.hasLoaded = true
        let sortedScans = stats.recentScans.sorted { $0.scanTimestamp > $1.scanTimestamp }
        state.$scanningStats.withLock {
          $0 = ScanningStats(
            totalScanned: stats.totalScanned,
            totalTickets: stats.totalTickets,
            recentScans: sortedScans
          )
        }
        state.$recentScans.withLock { $0 = sortedScans }
        return .none

      case .refreshResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none

      case .clearError:
        state.errorMessage = nil
        return .none
      }
    }
  }
}
