// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RequestHorseAudioMutation: GraphQLMutation {
  public static let operationName: String = "RequestHorseAudio"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation RequestHorseAudio($ticketId: UUID!) { requestHorseAudio(ticketId: $ticketId) { __typename ...HorseAudioClipFragment } }"#,
      fragments: [HorseAudioClipFragment.self]
    ))

  public var ticketId: UUID

  public init(ticketId: UUID) {
    self.ticketId = ticketId
  }

  public var __variables: Variables? { ["ticketId": ticketId] }

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("requestHorseAudio", RequestHorseAudio.self, arguments: ["ticketId": .variable("ticketId")]),
    ] }

    public var requestHorseAudio: RequestHorseAudio { __data["requestHorseAudio"] }

    /// RequestHorseAudio
    ///
    /// Parent Type: `HorseAudioClipPayload`
    public struct RequestHorseAudio: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.HorseAudioClipPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(HorseAudioClipFragment.self),
      ] }

      public var ownerName: String { __data["ownerName"] }
      public var ownerEmail: String { __data["ownerEmail"] }
      public var ticketAttendeeName: String { __data["ticketAttendeeName"] }
      public var horseNames: [String] { __data["horseNames"] }
      public var audioBase64: String { __data["audioBase64"] }
      public var prompt: String { __data["prompt"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var horseAudioClipFragment: HorseAudioClipFragment { _toFragment() }
      }
    }
  }
}
