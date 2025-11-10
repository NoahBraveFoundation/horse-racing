// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AllTicketsQuery: GraphQLQuery {
  public static let operationName: String = "AllTickets"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query AllTickets { allTickets { __typename ...TicketDirectoryFragment } }"#,
      fragments: [TicketDirectoryFragment.self, TicketFragment.self]
    ))

  public init() {}

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("allTickets", [AllTicket].self),
    ] }

    public var allTickets: [AllTicket] { __data["allTickets"] }

    /// AllTicket
    ///
    /// Parent Type: `Ticket`
    public struct AllTicket: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Ticket }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(TicketDirectoryFragment.self),
      ] }

      public var owner: Owner { __data["owner"] }
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

        public var ticketDirectoryFragment: TicketDirectoryFragment { _toFragment() }
        public var ticketFragment: TicketFragment { _toFragment() }
      }

      public typealias Owner = TicketDirectoryFragment.Owner
    }
  }
}
