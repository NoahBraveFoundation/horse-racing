import Fluent
import Vapor

struct MigrateTicketsAddScanning: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .field("scanned_at", .datetime)
            .field("scanned_by_user_id", .uuid, .references("users", "id"))
            .field("scan_location", .string)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .deleteField("scanned_at")
            .deleteField("scanned_by_user_id")
            .deleteField("scan_location")
            .update()
    }
}

