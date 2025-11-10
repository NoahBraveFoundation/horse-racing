import ComposableArchitecture
import Foundation

@Reducer
public struct AllTicketsFeature {
  @ObservableState
  public struct State: Equatable {
    public var tickets: [TicketDirectoryEntry] = []
    public var searchText = ""
    public var isLoading = false
    public var errorMessage: String?

    public init() {}

    public var filteredTickets: [TicketDirectoryEntry] {
      guard !searchText.isEmpty else { return tickets }
      return tickets.filter { $0.matches(searchText) }
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case refresh
    case retry
    case ticketsResponse(TaskResult<[TicketDirectoryEntry]>)
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
        state.tickets = tickets
        return .none

      case .ticketsResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none
      }
    }
  }
}
