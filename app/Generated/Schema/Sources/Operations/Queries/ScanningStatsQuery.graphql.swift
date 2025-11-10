// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ScanningStatsQuery: GraphQLQuery {
  public static let operationName: String = "ScanningStats"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ScanningStats { scanningStats { __typename totalScanned totalTickets recentScans { __typename ...TicketScanFragment } } }"#,
      fragments: [TicketFragment.self, TicketScanFragment.self, UserFragment.self]
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
          .fragment(TicketScanFragment.self),
        ] }

        public var id: HorseRacingAPI.UUID? { __data["id"] }
        public var scanTimestamp: HorseRacingAPI.Date { __data["scanTimestamp"] }
        public var scanLocation: String? { __data["scanLocation"] }
        public var ticket: Ticket { __data["ticket"] }
        public var scanner: Scanner { __data["scanner"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var ticketScanFragment: TicketScanFragment { _toFragment() }
        }

        public typealias Ticket = TicketScanFragment.Ticket

        public typealias Scanner = TicketScanFragment.Scanner
      }
    }
  }
}
