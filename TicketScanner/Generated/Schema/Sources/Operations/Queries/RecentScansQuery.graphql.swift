// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RecentScansQuery: GraphQLQuery {
  public static let operationName: String = "RecentScans"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RecentScans($limit: Int!) { recentScans(limit: $limit) { __typename id scanTimestamp scanLocation ticket { __typename id attendeeFirst attendeeLast seatAssignment } scanner { __typename firstName lastName } } }"#
    ))

  public var limit: Int

  public init(limit: Int) {
    self.limit = limit
  }

  public var __variables: Variables? { ["limit": limit] }

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("recentScans", [RecentScan].self, arguments: ["limit": .variable("limit")]),
    ] }

    public var recentScans: [RecentScan] { __data["recentScans"] }

    /// RecentScan
    ///
    /// Parent Type: `TicketScan`
    public struct RecentScan: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.TicketScan }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", HorseRacingAPI.UUID.self),
        .field("scanTimestamp", HorseRacingAPI.Date.self),
        .field("scanLocation", String?.self),
        .field("ticket", Ticket.self),
        .field("scanner", Scanner.self),
      ] }

      public var id: HorseRacingAPI.UUID { __data["id"] }
      public var scanTimestamp: HorseRacingAPI.Date { __data["scanTimestamp"] }
      public var scanLocation: String? { __data["scanLocation"] }
      public var ticket: Ticket { __data["ticket"] }
      public var scanner: Scanner { __data["scanner"] }

      /// RecentScan.Ticket
      ///
      /// Parent Type: `Ticket`
      public struct Ticket: HorseRacingAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Ticket }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", HorseRacingAPI.UUID.self),
          .field("attendeeFirst", String.self),
          .field("attendeeLast", String.self),
          .field("seatAssignment", String?.self),
        ] }

        public var id: HorseRacingAPI.UUID { __data["id"] }
        public var attendeeFirst: String { __data["attendeeFirst"] }
        public var attendeeLast: String { __data["attendeeLast"] }
        public var seatAssignment: String? { __data["seatAssignment"] }
      }

      /// RecentScan.Scanner
      ///
      /// Parent Type: `User`
      public struct Scanner: HorseRacingAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("firstName", String.self),
          .field("lastName", String.self),
        ] }

        public var firstName: String { __data["firstName"] }
        public var lastName: String { __data["lastName"] }
      }
    }
  }
}
