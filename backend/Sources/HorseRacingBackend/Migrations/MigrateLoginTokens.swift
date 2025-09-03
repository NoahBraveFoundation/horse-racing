import Fluent
import Vapor

struct MigrateLoginTokens: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("login_tokens")
			.id()
			.field("token", .string, .required)
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("expires_at", .datetime, .required)
			.field("created_at", .datetime)
			.unique(on: "token")
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("login_tokens").delete()
	}
}
