// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct TicketScanFragment: HorseRacingAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment TicketScanFragment on TicketScan { __typename id scanTimestamp scanLocation ticket { __typename ...TicketFragment } scanner { __typename ...UserFragment } }"#
  }

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

  /// Ticket
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

  /// Scanner
  ///
  /// Parent Type: `User`
  public struct Scanner: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(UserFragment.self),
    ] }

    public var id: HorseRacingAPI.UUID? { __data["id"] }
    public var email: String { __data["email"] }
    public var firstName: String { __data["firstName"] }
    public var lastName: String { __data["lastName"] }
    public var isAdmin: Bool { __data["isAdmin"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var userFragment: UserFragment { _toFragment() }
    }
  }
}
