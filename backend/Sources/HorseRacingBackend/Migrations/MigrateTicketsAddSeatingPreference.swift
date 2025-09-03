import Fluent
import Vapor

struct MigrateTicketsAddSeatingPreference: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .field("seating_preference", .string)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .deleteField("seating_preference")
            .update()
    }
}
