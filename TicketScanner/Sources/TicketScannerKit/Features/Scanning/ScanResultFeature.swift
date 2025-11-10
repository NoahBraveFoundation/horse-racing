import ComposableArchitecture
import Foundation

@Reducer
public struct ScanResultFeature {
  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: UUID
    public var result: ScanResult

    public init(id: UUID = UUID(), result: ScanResult) {
      self.id = id
      self.result = result
    }
  }

  public enum Action: Equatable {
    case doneButtonTapped
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { _, _ in
      .none
    }
  }
}
