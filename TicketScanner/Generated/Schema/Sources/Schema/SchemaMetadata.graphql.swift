// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == HorseRacingAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == HorseRacingAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == HorseRacingAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == HorseRacingAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "HorseAudioClipPayload": return HorseRacingAPI.Objects.HorseAudioClipPayload
    case "LoginPayload": return HorseRacingAPI.Objects.LoginPayload
    case "Mutation": return HorseRacingAPI.Objects.Mutation
    case "Query": return HorseRacingAPI.Objects.Query
    case "ScanTicketPayload": return HorseRacingAPI.Objects.ScanTicketPayload
    case "ScanningStats": return HorseRacingAPI.Objects.ScanningStats
    case "Ticket": return HorseRacingAPI.Objects.Ticket
    case "TicketScan": return HorseRacingAPI.Objects.TicketScan
    case "User": return HorseRacingAPI.Objects.User
    case "ValidateTokenPayload": return HorseRacingAPI.Objects.ValidateTokenPayload
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
