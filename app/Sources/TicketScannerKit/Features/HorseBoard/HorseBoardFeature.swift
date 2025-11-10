import ComposableArchitecture
import Foundation

@Reducer
public struct HorseBoardFeature {
  @ObservableState
  public struct State: Equatable {
    public var rounds: [HorseBoardRound] = []
    public var isLoading = false
    public var errorMessage: String?
    public var isInfoAlertPresented = false

    public init() {}
  }

  public enum Action: Equatable {
    case onAppear
    case refresh
    case refreshResponse(TaskResult<[HorseBoardRound]>)
    case dismissError
    case infoButtonTapped
    case infoAlertDismissed
  }

  @Dependency(\.apiClient) var apiClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        if state.rounds.isEmpty {
          return .send(.refresh)
        }
        return .none

      case .refresh:
        state.isLoading = true
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .refreshResponse(
              await TaskResult { try await apiClient.getHorseBoard() }
            )
          )
        }

      case .refreshResponse(.success(let rounds)):
        state.isLoading = false
        state.rounds = rounds.sorted { lhs, rhs in
          switch (lhs.startAt, rhs.startAt) {
          case (let lhsStart?, let rhsStart?):
            return lhsStart < rhsStart
          case (nil, nil):
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
          case (nil, _?):
            return false
          case (_?, nil):
            return true
          }
        }
        return .none

      case .refreshResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none

      case .dismissError:
        state.errorMessage = nil
        return .none

      case .infoButtonTapped:
        state.isInfoAlertPresented = true
        return .none

      case .infoAlertDismissed:
        state.isInfoAlertPresented = false
        return .none
      }
    }
  }
}
