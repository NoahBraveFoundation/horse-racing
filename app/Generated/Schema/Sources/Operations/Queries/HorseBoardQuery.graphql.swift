// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class HorseBoardQuery: GraphQLQuery {
  public static let operationName: String = "HorseBoard"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query HorseBoard { rounds { __typename id name startAt endAt lanes { __typename id number horse { __typename id horseName ownershipLabel state owner { __typename id firstName lastName email tickets { __typename id scannedAt } } } } } }"#
    ))

  public init() {}

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("rounds", [Round].self),
    ] }

    public var rounds: [Round] { __data["rounds"] }

    /// Round
    ///
    /// Parent Type: `Round`
    public struct Round: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Round }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", HorseRacingAPI.UUID?.self),
        .field("name", String.self),
        .field("startAt", HorseRacingAPI.Date.self),
        .field("endAt", HorseRacingAPI.Date.self),
        .field("lanes", [Lane].self),
      ] }

      public var id: HorseRacingAPI.UUID? { __data["id"] }
      public var name: String { __data["name"] }
      public var startAt: HorseRacingAPI.Date { __data["startAt"] }
      public var endAt: HorseRacingAPI.Date { __data["endAt"] }
      public var lanes: [Lane] { __data["lanes"] }

      /// Round.Lane
      ///
      /// Parent Type: `Lane`
      public struct Lane: HorseRacingAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Lane }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", HorseRacingAPI.UUID?.self),
          .field("number", Int.self),
          .field("horse", Horse?.self),
        ] }

        public var id: HorseRacingAPI.UUID? { __data["id"] }
        public var number: Int { __data["number"] }
        public var horse: Horse? { __data["horse"] }

        /// Round.Lane.Horse
        ///
        /// Parent Type: `Horse`
        public struct Horse: HorseRacingAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Horse }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", HorseRacingAPI.UUID?.self),
            .field("horseName", String.self),
            .field("ownershipLabel", String.self),
            .field("state", GraphQLEnum<HorseRacingAPI.HorseEntryState>.self),
            .field("owner", Owner.self),
          ] }

          public var id: HorseRacingAPI.UUID? { __data["id"] }
          public var horseName: String { __data["horseName"] }
          public var ownershipLabel: String { __data["ownershipLabel"] }
          public var state: GraphQLEnum<HorseRacingAPI.HorseEntryState> { __data["state"] }
          public var owner: Owner { __data["owner"] }

          /// Round.Lane.Horse.Owner
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
              .field("tickets", [Ticket].self),
            ] }

            public var id: HorseRacingAPI.UUID? { __data["id"] }
            public var firstName: String { __data["firstName"] }
            public var lastName: String { __data["lastName"] }
            public var email: String { __data["email"] }
            public var tickets: [Ticket] { __data["tickets"] }

            /// Round.Lane.Horse.Owner.Ticket
            ///
            /// Parent Type: `Ticket`
            public struct Ticket: HorseRacingAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Ticket }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", HorseRacingAPI.UUID?.self),
                .field("scannedAt", HorseRacingAPI.Date?.self),
              ] }

              public var id: HorseRacingAPI.UUID? { __data["id"] }
              public var scannedAt: HorseRacingAPI.Date? { __data["scannedAt"] }
            }
          }
        }
      }
    }
  }
}
