// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ScanTicketMutation: GraphQLMutation {
  public static let operationName: String = "ScanTicket"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation ScanTicket($ticketId: UUID!, $scanLocation: String, $deviceInfo: String) { scanTicket( ticketId: $ticketId scanLocation: $scanLocation deviceInfo: $deviceInfo ) { __typename success message ticket { __typename id attendeeFirst attendeeLast seatingPreference seatAssignment state scannedAt scanLocation } alreadyScanned previousScan { __typename id scanTimestamp scanLocation scanner { __typename firstName lastName } } } }"#
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
          .field("id", HorseRacingAPI.UUID?.self),
          .field("attendeeFirst", String.self),
          .field("attendeeLast", String.self),
          .field("seatingPreference", String?.self),
          .field("seatAssignment", String?.self),
          .field("state", GraphQLEnum<HorseRacingAPI.TicketState>.self),
          .field("scannedAt", HorseRacingAPI.Date?.self),
          .field("scanLocation", String?.self),
        ] }

        public var id: HorseRacingAPI.UUID? { __data["id"] }
        public var attendeeFirst: String { __data["attendeeFirst"] }
        public var attendeeLast: String { __data["attendeeLast"] }
        public var seatingPreference: String? { __data["seatingPreference"] }
        public var seatAssignment: String? { __data["seatAssignment"] }
        public var state: GraphQLEnum<HorseRacingAPI.TicketState> { __data["state"] }
        public var scannedAt: HorseRacingAPI.Date? { __data["scannedAt"] }
        public var scanLocation: String? { __data["scanLocation"] }
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
          .field("id", HorseRacingAPI.UUID?.self),
          .field("scanTimestamp", HorseRacingAPI.Date.self),
          .field("scanLocation", String?.self),
          .field("scanner", Scanner.self),
        ] }

        public var id: HorseRacingAPI.UUID? { __data["id"] }
        public var scanTimestamp: HorseRacingAPI.Date { __data["scanTimestamp"] }
        public var scanLocation: String? { __data["scanLocation"] }
        public var scanner: Scanner { __data["scanner"] }

        /// ScanTicket.PreviousScan.Scanner
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
