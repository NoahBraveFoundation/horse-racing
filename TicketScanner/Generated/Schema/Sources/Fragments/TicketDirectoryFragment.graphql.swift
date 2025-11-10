// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct TicketDirectoryFragment: HorseRacingAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment TicketDirectoryFragment on Ticket { __typename ...TicketFragment owner { __typename id firstName lastName email } cart { __typename id orderNumber tickets { __typename id attendeeFirst attendeeLast scannedAt } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Ticket }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("owner", Owner.self),
    .field("cart", Cart?.self),
    .fragment(TicketFragment.self),
  ] }

  public var owner: Owner { __data["owner"] }
  public var cart: Cart? { __data["cart"] }
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

  /// Owner
  ///
  /// Parent Type: `User`
  public struct Owner: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", HorseRacingAPI.UUID?.self),
      .field("firstName", String.self),
      .field("lastName", String.self),
      .field("email", String.self),
    ] }

    public var id: HorseRacingAPI.UUID? { __data["id"] }
    public var firstName: String { __data["firstName"] }
    public var lastName: String { __data["lastName"] }
    public var email: String { __data["email"] }
  }

  /// Cart
  ///
  /// Parent Type: `Cart`
  public struct Cart: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Cart }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", HorseRacingAPI.UUID?.self),
      .field("orderNumber", String.self),
      .field("tickets", [Ticket].self),
    ] }

    public var id: HorseRacingAPI.UUID? { __data["id"] }
    public var orderNumber: String { __data["orderNumber"] }
    public var tickets: [Ticket] { __data["tickets"] }

    /// Cart.Ticket
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
        .field("scannedAt", HorseRacingAPI.Date?.self),
      ] }

      public var id: HorseRacingAPI.UUID? { __data["id"] }
      public var attendeeFirst: String { __data["attendeeFirst"] }
      public var attendeeLast: String { __data["attendeeLast"] }
      public var scannedAt: HorseRacingAPI.Date? { __data["scannedAt"] }
    }
  }
}
