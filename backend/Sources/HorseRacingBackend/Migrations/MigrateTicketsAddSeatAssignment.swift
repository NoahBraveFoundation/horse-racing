import Fluent
import Vapor

struct MigrateTicketsAddSeatAssignment: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .field("seat_assignment", .string)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .deleteField("seat_assignment")
            .update()
    }
}
