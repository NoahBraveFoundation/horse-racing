import Fluent
import Vapor

struct MigrateSponsorInterests: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sponsor_interests")
			.id()
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("company_name", .string, .required)
			.field("created_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sponsor_interests").delete()
	}
}
