import Foundation
@preconcurrency import Graphiti
import Vapor

// Definition of our GraphQL schema
let horseRacingSchema = try! Schema<HorseResolver, Request> {
    Scalar(UUID.self)
    Scalar(Date.self)
    
    // Horse type with its fields
    Type(Horse.self) {
        Field("id", at: \.id)
        Field("name", at: \.name)
        Field("breed", at: \.breed)
        Field("age", at: \.age)
        Field("jockey", at: \.jockey)
        Field("odds", at: \.odds)
    }
    
    // Race type with its fields
    Type(Race.self) {
        Field("id", at: \.id)
        Field("name", at: \.name)
        Field("date", at: \.date)
        Field("distance", at: \.distance)
        Field("status", at: \.status)
    }
    
    // Queries
    Query {
        Field("horses", at: HorseResolver.getAllHorses)
        Field("horse", at: HorseResolver.getHorse) {
            Argument("id", at: \.id)
        }
        Field("races", at: HorseResolver.getAllRaces)
        Field("race", at: HorseResolver.getRace) {
            Argument("id", at: \.id)
        }
    }
    
    // Mutations
    Mutation {
        Field("createHorse", at: HorseResolver.createHorse) {
            Argument("name", at: \.name)
            Argument("breed", at: \.breed)
            Argument("age", at: \.age)
            Argument("jockey", at: \.jockey)
            Argument("odds", at: \.odds)
        }
        
        Field("deleteHorse", at: HorseResolver.deleteHorse) {
            Argument("id", at: \.id)
        }
        
        Field("createRace", at: HorseResolver.createRace) {
            Argument("name", at: \.name)
            Argument("date", at: \.date)
            Argument("distance", at: \.distance)
            Argument("status", at: \.status)
        }
        
        Field("updateRaceStatus", at: HorseResolver.updateRaceStatus) {
            Argument("id", at: \.id)
            Argument("status", at: \.status)
        }
    }
}
