import ComposableArchitecture
import Foundation
import Sharing

@Reducer
public struct SettingsFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.appStorage(SharedStorageKey.hapticsEnabled))
    public var hapticsEnabled: Bool = true

    @Shared(.appStorage(SharedStorageKey.audioFeedbackEnabled))
    public var audioFeedbackEnabled: Bool = true

    @Shared(.appStorage(SharedStorageKey.horseGreetingsEnabled))
    public var horseGreetingsEnabled: Bool = true

    public init() {}
  }

  public enum Action: Equatable {
    case setHapticsEnabled(Bool)
    case setAudioFeedbackEnabled(Bool)
    case setHorseGreetingsEnabled(Bool)
    case logoutTapped
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .setHapticsEnabled(let isEnabled):
        state.$hapticsEnabled.withLock { $0 = isEnabled }
        return .none

      case .setAudioFeedbackEnabled(let isEnabled):
        state.$audioFeedbackEnabled.withLock { $0 = isEnabled }
        return .none

      case .setHorseGreetingsEnabled(let isEnabled):
        state.$horseGreetingsEnabled.withLock { $0 = isEnabled }
        return .none

      case .logoutTapped:
        return .none
      }
    }
  }
}
