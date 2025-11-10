import ComposableArchitecture
import Dependencies
import Foundation
import Sharing

@Reducer
public struct SeatAssignmentEditorFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.appStorage(SharedStorageKey.tickets))
    public var tickets: [TicketDirectoryEntry] = []
    public let ticketID: UUID
    public var seatAssignmentText: String
    public var isSaving = false
    public var errorMessage: String?

    public init(ticketID: UUID, initialSeatAssignment: String) {
      self.ticketID = ticketID
      self.seatAssignmentText = initialSeatAssignment
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case saveResponse(TaskResult<Ticket>)
    case dismissTapped
    case clearError
    case delegate(DelegateAction)
  }

  public enum DelegateAction: Equatable {
    case finished
  }

  @Dependency(\.apiClient) var apiClient

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .saveButtonTapped:
        state.isSaving = true
        state.errorMessage = nil
        let draft = state.seatAssignmentText.trimmingCharacters(in: .whitespacesAndNewlines)
        let assignment = draft.isEmpty ? nil : draft
        return .run { [ticketID = state.ticketID, assignment] send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .saveResponse(
              await TaskResult {
                try await apiClient.setTicketSeatAssignment(ticketID, assignment)
              }
            ))
        }

      case .saveResponse(.success(let ticket)):
        state.isSaving = false
        state.errorMessage = nil
        state.$tickets.withLock { tickets in
          if let index = tickets.firstIndex(where: { $0.id == ticket.id }) {
            let existing = tickets[index]
            tickets[index] = TicketDirectoryEntry(
              ticket: ticket,
              ownerName: existing.ownerName,
              ownerEmail: existing.ownerEmail,
              orderNumber: existing.orderNumber,
              associatedTickets: existing.associatedTickets,
              horses: existing.horses
            )
          }
        }
        return .send(.delegate(.finished))

      case .saveResponse(.failure(let error)):
        state.isSaving = false
        state.errorMessage = error.localizedDescription
        return .none

      case .dismissTapped:
        return .send(.delegate(.finished))

      case .clearError:
        state.errorMessage = nil
        return .none

      case .delegate:
        return .none
      }
    }
  }
}
