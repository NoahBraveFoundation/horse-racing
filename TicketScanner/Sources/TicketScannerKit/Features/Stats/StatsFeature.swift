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
    public var path = StackState<Path.State>()

    public init() {}
  }

  public enum Action: Equatable {
    case onAppear
    case refresh(RefreshTrigger)
    case refreshResponse(TaskResult<ScanningStats>)
    case clearError
    case openTicket(UUID)
    case unscanTicket(UUID)
    case unscanResponse(TaskResult<ScanTicketResponse>)
    case path(StackAction<Path.State, Path.Action>)
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

      case .openTicket(let id):
        state.path.append(.detail(TicketDetailFeature.State(ticketID: id)))
        return .none

      case .unscanTicket(let ticketId):
        // Find the most recent scan for this ticket
        guard let latestScan = state.recentScans.first(where: { $0.ticket.id == ticketId }) else {
          state.errorMessage = "No scan found for this ticket"
          return .none
        }

        state.isLoading = true
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .unscanResponse(
              await TaskResult {
                try await apiClient.undoScan(latestScan.id.uuidString)
              }
            ))
        }

      case .unscanResponse(.success(let response)):
        state.isLoading = false
        if !response.success {
          state.errorMessage = response.message
        }
        return .send(.refresh(.scanUpdate))

      case .unscanResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none

      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
  }
}

extension StatsFeature {
  @Reducer
  public struct Path {
    @ObservableState
    public enum State: Equatable {
      case detail(TicketDetailFeature.State)
    }

    public enum Action: Equatable {
      case detail(TicketDetailFeature.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: \.detail, action: \.detail) {
        TicketDetailFeature()
      }
    }
  }
}
