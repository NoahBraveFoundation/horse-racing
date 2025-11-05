import Fluent
import Vapor

struct MigratePayments: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("payments")
			.id()
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("total_cents", .int, .required)
			.field("payment_received", .bool, .required)
			.field("payment_received_at", .datetime)
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.unique(on: "user_id")
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("payments").delete()
	}
}
