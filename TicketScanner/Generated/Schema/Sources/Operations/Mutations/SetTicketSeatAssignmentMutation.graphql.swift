// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SetTicketSeatAssignmentMutation: GraphQLMutation {
  public static let operationName: String = "SetTicketSeatAssignment"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation SetTicketSeatAssignment($ticketId: UUID!, $seatAssignment: String) { setTicketSeatAssignment(ticketId: $ticketId, seatAssignment: $seatAssignment) { __typename ...TicketFragment } }"#,
      fragments: [TicketFragment.self]
    ))

  public var ticketId: UUID
  public var seatAssignment: GraphQLNullable<String>

  public init(
    ticketId: UUID,
    seatAssignment: GraphQLNullable<String>
  ) {
    self.ticketId = ticketId
    self.seatAssignment = seatAssignment
  }

  public var __variables: Variables? { [
    "ticketId": ticketId,
    "seatAssignment": seatAssignment
  ] }

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("setTicketSeatAssignment", SetTicketSeatAssignment.self, arguments: [
        "ticketId": .variable("ticketId"),
        "seatAssignment": .variable("seatAssignment")
      ]),
    ] }

    public var setTicketSeatAssignment: SetTicketSeatAssignment { __data["setTicketSeatAssignment"] }

    /// SetTicketSeatAssignment
    ///
    /// Parent Type: `Ticket`
    public struct SetTicketSeatAssignment: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Ticket }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(TicketFragment.self),
      ] }

      public var id: HorseRacingAPI.UUID? { __data["id"] }
      public var attendeeFirst: String { __data["attendeeFirst"] }
      public var attendeeLast: String { __data["attendeeLast"] }
      public var seatingPreference: String? { __data["seatingPreference"] }
      public var seatAssignment: String? { __data["seatAssignment"] }
      public var state: GraphQLEnum<HorseRacingAPI.TicketState> { __data["state"] }
      public var scannedAt: HorseRacingAPI.Date? { __data["scannedAt"] }
      public var scanLocation: String? { __data["scanLocation"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var ticketFragment: TicketFragment { _toFragment() }
      }
    }
  }
}
