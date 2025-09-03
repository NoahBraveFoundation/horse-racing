import Fluent
import Vapor

struct MigrateTicketsAddCanRemove: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .field("can_remove", .bool, .required, .sql(.default(false)))
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .deleteField("can_remove")
            .update()
    }
}
