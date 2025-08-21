import Vapor
import Graphiti

final class HorseResolver {
    // Horse methods
    func getAllHorses(request: Request, _: NoArguments) throws -> EventLoopFuture<[Horse]> {
        Horse.query(on: request.db).all()
    }
    
    func getHorse(request: Request, arguments: GetHorseArguments) throws -> EventLoopFuture<Horse?> {
        Horse.find(arguments.id, on: request.db)
    }
    
    func createHorse(request: Request, arguments: CreateHorseArguments) throws -> EventLoopFuture<Horse> {
        let horse = Horse(
            name: arguments.name,
            breed: arguments.breed,
            age: arguments.age,
            jockey: arguments.jockey,
            odds: arguments.odds
        )
        return horse.create(on: request.db).map { horse }
    }
    
    func deleteHorse(request: Request, arguments: DeleteHorseArguments) throws -> EventLoopFuture<Bool> {
        Horse.find(arguments.id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap({ $0.delete(on: request.db) })
            .transform(to: true)
    }
    
    // Race methods
    func getAllRaces(request: Request, _: NoArguments) throws -> EventLoopFuture<[Race]> {
        Race.query(on: request.db).all()
    }
    
    func getRace(request: Request, arguments: GetRaceArguments) throws -> EventLoopFuture<Race?> {
        Race.find(arguments.id, on: request.db)
    }
    
    func createRace(request: Request, arguments: CreateRaceArguments) throws -> EventLoopFuture<Race> {
        let race = Race(
            name: arguments.name,
            date: arguments.date,
            distance: arguments.distance,
            status: arguments.status
        )
        return race.create(on: request.db).map { race }
    }
    
    func updateRaceStatus(request: Request, arguments: UpdateRaceStatusArguments) throws -> EventLoopFuture<Race> {
        Race.find(arguments.id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { race in
                race.status = arguments.status
                return race.save(on: request.db).map { race }
            }
    }
}

// Argument types for GraphQL
extension HorseResolver {
    struct GetHorseArguments: Codable {
        let id: UUID
    }
    
    struct CreateHorseArguments: Codable {
        let name: String
        let breed: String
        let age: Int
        let jockey: String
        let odds: Double
    }
    
    struct DeleteHorseArguments: Codable {
        let id: UUID
    }
    
    struct GetRaceArguments: Codable {
        let id: UUID
    }
    
    struct CreateRaceArguments: Codable {
        let name: String
        let date: Date
        let distance: Int
        let status: RaceStatus
    }
    
    struct UpdateRaceStatusArguments: Codable {
        let id: UUID
        let status: RaceStatus
    }
}
