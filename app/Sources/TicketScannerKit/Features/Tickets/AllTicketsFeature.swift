import ComposableArchitecture
import Foundation
import Sharing

@Reducer
public struct AllTicketsFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.appStorage(SharedStorageKey.tickets))
    public var tickets: [TicketDirectoryEntry] = []
    public var searchText = ""
    public var filter: Filter = .all
    public var isLoading = false
    public var errorMessage: String?
    public var path = StackState<Path.State>()

    public init() {}

    public var filteredTickets: [TicketDirectoryEntry] {
      let base: [TicketDirectoryEntry]
      if searchText.isEmpty {
        base = tickets
      } else {
        base = tickets.filter { $0.matches(searchText) }
      }

      switch filter {
      case .all:
        return base
      case .scanned:
        return base.filter { $0.ticket.isScanned }
      case .unscanned:
        return base.filter { !$0.ticket.isScanned }
      }
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case refresh
    case retry
    case ticketsResponse(TaskResult<[TicketDirectoryEntry]>)
    case rowTapped(UUID)
    case unscanTicket(UUID)
    case unscanResponse(TaskResult<ScanTicketResponse>)
    case showHorseBoard
    case path(StackAction<Path.State, Path.Action>)
  }

  @Dependency(\.apiClient) var apiClient

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .onAppear:
        if state.tickets.isEmpty {
          return .send(.refresh)
        }
        return .none

      case .refresh, .retry:
        state.isLoading = true
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .ticketsResponse(
              await TaskResult {
                try await apiClient.getAllTickets()
              }
            ))
        }

      case .ticketsResponse(.success(let tickets)):
        state.isLoading = false
        state.$tickets.withLock { $0 = tickets }
        return .none

      case .ticketsResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none

      case .rowTapped(let id):
        if state.tickets.contains(where: { $0.id == id }) {
          state.path.append(.detail(TicketDetailFeature.State(ticketID: id)))
        }
        return .none

      case .showHorseBoard:
        state.path.append(.horseBoard(HorseBoardFeature.State()))
        return .none

      case .unscanTicket(let ticketId):
        // Find the ticket to get its scan history
        guard let entry = state.tickets.first(where: { $0.id == ticketId }),
          entry.ticket.isScanned
        else {
          state.errorMessage = "Ticket is not scanned"
          return .none
        }

        state.isLoading = true
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          // Get scan history to find the latest scan ID
          let scans = try await apiClient.getRecentScans(100)
          guard let latestScan = scans.first(where: { $0.ticket.id == ticketId }) else {
            await send(
              .unscanResponse(
                .failure(
                  NSError(
                    domain: "AllTicketsFeature", code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "No scan history found"]))))
            return
          }

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
        return .send(.refresh)

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

extension AllTicketsFeature.State {
  public enum Filter: String, CaseIterable, Equatable, Sendable {
    case all
    case scanned
    case unscanned

    public var title: String {
      switch self {
      case .all:
        return "All"
      case .scanned:
        return "Scanned"
      case .unscanned:
        return "Unscanned"
      }
    }
  }
}

extension AllTicketsFeature {
  @Reducer
  public struct Path {
    @ObservableState
    public enum State: Equatable {
      case detail(TicketDetailFeature.State)
      case horseBoard(HorseBoardFeature.State)
    }

    public enum Action: Equatable {
      case detail(TicketDetailFeature.Action)
      case horseBoard(HorseBoardFeature.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: \.detail, action: \.detail) {
        TicketDetailFeature()
      }
      Scope(state: \.horseBoard, action: \.horseBoard) {
        HorseBoardFeature()
      }
    }
  }
}
