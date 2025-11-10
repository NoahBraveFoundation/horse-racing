// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct UserFragment: HorseRacingAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment UserFragment on User { __typename id email firstName lastName isAdmin }"#
  }

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
