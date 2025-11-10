import ComposableArchitecture
import Foundation

@Reducer
public struct ScanResultFeature {
  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: UUID
    public var result: ScanResult
    public var isLoading: Bool

    public init(id: UUID = UUID(), result: ScanResult, isLoading: Bool = false) {
      self.id = id
      self.result = result
      self.isLoading = isLoading
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
