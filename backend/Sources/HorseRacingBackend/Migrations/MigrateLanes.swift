import Fluent
import Vapor

struct MigrateLanes: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("lanes")
			.id()
			.field("round_id", .uuid, .required, .references("rounds", "id", onDelete: .cascade))
			.field("number", .int, .required)
			.field("created_at", .datetime)
			.unique(on: "round_id", "number")
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("lanes").delete()
	}
}
