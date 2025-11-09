// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ValidateTokenMutation: GraphQLMutation {
  public static let operationName: String = "ValidateToken"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation ValidateToken($token: String!) { validateToken(token: $token) { __typename success message user { __typename id email firstName lastName isAdmin } } }"#
    ))

  public var token: String

  public init(token: String) {
    self.token = token
  }

  public var __variables: Variables? { ["token": token] }

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("validateToken", ValidateToken.self, arguments: ["token": .variable("token")]),
    ] }

    public var validateToken: ValidateToken { __data["validateToken"] }

    /// ValidateToken
    ///
    /// Parent Type: `ValidateTokenPayload`
    public struct ValidateToken: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.ValidateTokenPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool.self),
        .field("message", String.self),
        .field("user", User?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var message: String { __data["message"] }
      public var user: User? { __data["user"] }

      /// ValidateToken.User
      ///
      /// Parent Type: `User`
      public struct User: HorseRacingAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", HorseRacingAPI.UUID?.self),
          .field("email", String.self),
          .field("firstName", String.self),
          .field("lastName", String.self),
          .field("isAdmin", Bool.self),
        ] }

        public var id: HorseRacingAPI.UUID? { __data["id"] }
        public var email: String { __data["email"] }
        public var firstName: String { __data["firstName"] }
        public var lastName: String { __data["lastName"] }
        public var isAdmin: Bool { __data["isAdmin"] }
      }
    }
  }
}
