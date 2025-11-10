// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RecentScansQuery: GraphQLQuery {
  public static let operationName: String = "RecentScans"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RecentScans($limit: Int!) { recentScans(limit: $limit) { __typename ...TicketScanFragment } }"#,
      fragments: [TicketFragment.self, TicketScanFragment.self, UserFragment.self]
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
