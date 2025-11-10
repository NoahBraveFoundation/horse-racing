// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct HorseAudioClipFragment: HorseRacingAPI.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment HorseAudioClipFragment on HorseAudioClip { __typename ownerName ownerEmail ticketAttendeeName horseNames audioBase64 prompt }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { HorseRacingAPI.Objects.HorseAudioClip }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("ownerName", String.self),
    .field("ownerEmail", String.self),
    .field("ticketAttendeeName", String.self),
    .field("horseNames", [String].self),
    .field("audioBase64", String.self),
    .field("prompt", String.self),
  ] }

  public var ownerName: String { __data["ownerName"] }
  public var ownerEmail: String { __data["ownerEmail"] }
  public var ticketAttendeeName: String { __data["ticketAttendeeName"] }
  public var horseNames: [String] { __data["horseNames"] }
  public var audioBase64: String { __data["audioBase64"] }
  public var prompt: String { __data["prompt"] }
}
