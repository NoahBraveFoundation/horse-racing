// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TicketByBarcodeQuery: GraphQLQuery {
  public static let operationName: String = "TicketByBarcode"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TicketByBarcode($barcode: String!) { ticketByBarcode(barcode: $barcode) { __typename id attendeeFirst attendeeLast seatingPreference seatAssignment state scannedAt scanLocation } }"#
    ))

  public var barcode: String

  public init(barcode: String) {
    self.barcode = barcode
  }

  public var __variables: Variables? { ["barcode": barcode] }

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("ticketByBarcode", TicketByBarcode?.self, arguments: ["barcode": .variable("barcode")]),
    ] }

    public var ticketByBarcode: TicketByBarcode? { __data["ticketByBarcode"] }

    /// TicketByBarcode
    ///
    /// Parent Type: `Ticket`
    public struct TicketByBarcode: HorseRacingAPI.SelectionSet {
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
  }
}
