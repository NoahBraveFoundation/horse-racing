import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct AuthenticationFeature {
  @ObservableState
  public struct State: Equatable {
    var email: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var isLinkSent: Bool = false

    public init() {}
  }

  public enum Action: Equatable {
    case emailChanged(String)
    case sendMagicLinkTapped
    case sendMagicLinkResponse(TaskResult<Bool>)
    case validateToken(String)
    case validateTokenResponse(TaskResult<User>)
    case logout
  }

  @Dependency(\.apiClient) var apiClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .emailChanged(let email):
        state.email = email
        state.errorMessage = nil
        return .none

      case .sendMagicLinkTapped:
        guard !state.email.isEmpty else {
          state.errorMessage = "Please enter your email"
          return .none
        }

        state.isLoading = true
        state.errorMessage = nil

        return .run { [email = state.email] send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .sendMagicLinkResponse(
              await TaskResult {
                try await apiClient.sendMagicLink(email)
                return true
              }
            ))
        }

      case .sendMagicLinkResponse(.success(_)):
        state.isLoading = false
        state.isLinkSent = true
        return .none

      case .sendMagicLinkResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none
        
      case .validateToken(let token):
        state.isLoading = true
        state.errorMessage = nil
        
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .validateTokenResponse(
              await TaskResult {
                try await apiClient.validateToken(token)
              }
            ))
        }
        
      case .validateTokenResponse(.success(_)):
        state.isLoading = false
        // Parent will handle navigation
        return .none

      case .validateTokenResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none

      case .logout:
        state = State()
        return .none
      }
    }
  }
}
