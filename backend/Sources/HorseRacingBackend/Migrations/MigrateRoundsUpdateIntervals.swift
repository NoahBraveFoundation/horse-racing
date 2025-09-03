import Fluent
import Vapor

struct MigrateRoundsUpdateIntervals: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Get all existing rounds and update their intervals to 10 minutes
        return Round.query(on: database).sort(\.$startAt, .ascending).all().flatMap { rounds in
            guard let firstRound = rounds.first else { return database.eventLoop.makeSucceededFuture(()) }
            
            let updateFutures = rounds.enumerated().map { (index, round) in
                // Calculate new start time: first round start + (index * 10 minutes)
                let newStartAt = firstRound.startAt.addingTimeInterval(TimeInterval(index * 10 * 60))
                // Calculate new end time: start time + 10 minutes
                let newEndAt = newStartAt.addingTimeInterval(10 * 60)
                
                round.startAt = newStartAt
                round.endAt = newEndAt
                return round.update(on: database)
            }
            return EventLoopFuture.andAllSucceed(updateFutures, on: database.eventLoop)
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        // Revert back to 30-minute intervals
        return Round.query(on: database).sort(\.$startAt, .ascending).all().flatMap { rounds in
            guard let firstRound = rounds.first else { return database.eventLoop.makeSucceededFuture(()) }
            
            let updateFutures = rounds.enumerated().map { (index, round) in
                // Calculate new start time: first round start + (index * 30 minutes)
                let newStartAt = firstRound.startAt.addingTimeInterval(TimeInterval(index * 30 * 60))
                // Calculate new end time: start time + 30 minutes
                let newEndAt = newStartAt.addingTimeInterval(30 * 60)
                
                round.startAt = newStartAt
                round.endAt = newEndAt
                return round.update(on: database)
            }
            return EventLoopFuture.andAllSucceed(updateFutures, on: database.eventLoop)
        }
    }
}
