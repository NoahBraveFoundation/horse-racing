// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ScanTicketMutation: GraphQLMutation {
  public static let operationName: String = "ScanTicket"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation ScanTicket($ticketId: UUID!, $scanLocation: String, $deviceInfo: String) { scanTicket( ticketId: $ticketId scanLocation: $scanLocation deviceInfo: $deviceInfo ) { __typename success message ticket { __typename ...TicketFragment } alreadyScanned previousScan { __typename ...TicketScanFragment } } }"#,
      fragments: [TicketFragment.self, TicketScanFragment.self, UserFragment.self]
    ))

  public var ticketId: UUID
  public var scanLocation: GraphQLNullable<String>
  public var deviceInfo: GraphQLNullable<String>

  public init(
    ticketId: UUID,
    scanLocation: GraphQLNullable<String>,
    deviceInfo: GraphQLNullable<String>
  ) {
    self.ticketId = ticketId
    self.scanLocation = scanLocation
    self.deviceInfo = deviceInfo
  }

  public var __variables: Variables? { [
    "ticketId": ticketId,
    "scanLocation": scanLocation,
    "deviceInfo": deviceInfo
  ] }

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("scanTicket", ScanTicket.self, arguments: [
        "ticketId": .variable("ticketId"),
        "scanLocation": .variable("scanLocation"),
        "deviceInfo": .variable("deviceInfo")
      ]),
    ] }

    public var scanTicket: ScanTicket { __data["scanTicket"] }

    /// ScanTicket
    ///
    /// Parent Type: `ScanTicketPayload`
    public struct ScanTicket: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.ScanTicketPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool.self),
        .field("message", String.self),
        .field("ticket", Ticket?.self),
        .field("alreadyScanned", Bool.self),
        .field("previousScan", PreviousScan?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var message: String { __data["message"] }
      public var ticket: Ticket? { __data["ticket"] }
      public var alreadyScanned: Bool { __data["alreadyScanned"] }
      public var previousScan: PreviousScan? { __data["previousScan"] }

      /// ScanTicket.Ticket
      ///
      /// Parent Type: `Ticket`
      public struct Ticket: HorseRacingAPI.SelectionSet {
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

      /// ScanTicket.PreviousScan
      ///
      /// Parent Type: `TicketScan`
      public struct PreviousScan: HorseRacingAPI.SelectionSet {
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
