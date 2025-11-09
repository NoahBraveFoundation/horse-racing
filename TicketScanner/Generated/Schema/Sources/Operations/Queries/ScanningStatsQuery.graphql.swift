// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ScanningStatsQuery: GraphQLQuery {
  public static let operationName: String = "ScanningStats"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ScanningStats { scanningStats { __typename totalScanned totalTickets recentScans { __typename id scanTimestamp scanLocation ticket { __typename attendeeFirst attendeeLast } scanner { __typename firstName lastName } } } }"#
    ))

  public init() {}

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("scanningStats", ScanningStats.self),
    ] }

    public var scanningStats: ScanningStats { __data["scanningStats"] }

    /// ScanningStats
    ///
    /// Parent Type: `ScanningStats`
    public struct ScanningStats: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.ScanningStats }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("totalScanned", Int.self),
        .field("totalTickets", Int.self),
        .field("recentScans", [RecentScan].self),
      ] }

      public var totalScanned: Int { __data["totalScanned"] }
      public var totalTickets: Int { __data["totalTickets"] }
      public var recentScans: [RecentScan] { __data["recentScans"] }

      /// ScanningStats.RecentScan
      ///
      /// Parent Type: `TicketScan`
      public struct RecentScan: HorseRacingAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.TicketScan }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", HorseRacingAPI.UUID?.self),
          .field("scanTimestamp", HorseRacingAPI.Date.self),
          .field("scanLocation", String?.self),
          .field("ticket", Ticket.self),
          .field("scanner", Scanner.self),
        ] }

        public var id: HorseRacingAPI.UUID? { __data["id"] }
        public var scanTimestamp: HorseRacingAPI.Date { __data["scanTimestamp"] }
        public var scanLocation: String? { __data["scanLocation"] }
        public var ticket: Ticket { __data["ticket"] }
        public var scanner: Scanner { __data["scanner"] }

        /// ScanningStats.RecentScan.Ticket
        ///
        /// Parent Type: `Ticket`
        public struct Ticket: HorseRacingAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Ticket }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("attendeeFirst", String.self),
            .field("attendeeLast", String.self),
          ] }

          public var attendeeFirst: String { __data["attendeeFirst"] }
          public var attendeeLast: String { __data["attendeeLast"] }
        }

        /// ScanningStats.RecentScan.Scanner
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
}
