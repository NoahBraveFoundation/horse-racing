// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LoginMutation: GraphQLMutation {
  public static let operationName: String = "Login"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation Login($email: String!, $redirectTo: String) { login(email: $email, redirectTo: $redirectTo) { __typename success message tokenId } }"#
    ))

  public var email: String
  public var redirectTo: GraphQLNullable<String>

  public init(
    email: String,
    redirectTo: GraphQLNullable<String>
  ) {
    self.email = email
    self.redirectTo = redirectTo
  }

  public var __variables: Variables? { [
    "email": email,
    "redirectTo": redirectTo
  ] }

  public struct Data: HorseRacingAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("login", Login.self, arguments: [
        "email": .variable("email"),
        "redirectTo": .variable("redirectTo")
      ]),
    ] }

    public var login: Login { __data["login"] }

    /// Login
    ///
    /// Parent Type: `LoginPayload`
    public struct Login: HorseRacingAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.LoginPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool.self),
        .field("message", String.self),
        .field("tokenId", String?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var message: String { __data["message"] }
      public var tokenId: String? { __data["tokenId"] }
    }
  }
}
