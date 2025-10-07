import Fluent
import Vapor

struct MigrateTicketScans: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("ticket_scans")
            .id()
            .field("ticket_id", .uuid, .required, .references("tickets", "id", onDelete: .cascade))
            .field("scanner_user_id", .uuid, .required, .references("users", "id"))
            .field("scan_timestamp", .datetime, .required)
            .field("scan_location", .string)
            .field("device_info", .string)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("ticket_scans").delete()
    }
}

