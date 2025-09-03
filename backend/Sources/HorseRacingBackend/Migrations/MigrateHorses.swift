import Fluent
import Vapor

struct MigrateHorses: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("horses")
			.id()
			.field("owner_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("round_id", .uuid, .required, .references("rounds", "id", onDelete: .cascade))
			.field("lane_id", .uuid, .required, .references("lanes", "id", onDelete: .cascade))
			.field("horse_name", .string, .required)
			.field("ownership_label", .string, .required)
			.field("state", .string, .required)
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.unique(on: "owner_id", "round_id")
			.unique(on: "lane_id")
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("horses").delete()
	}
}
