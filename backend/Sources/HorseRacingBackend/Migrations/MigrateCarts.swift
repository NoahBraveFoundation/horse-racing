import Fluent
import Vapor

struct MigrateCarts: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("carts")
			.id()
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("status", .string, .required)
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("carts").delete()
	}
}
