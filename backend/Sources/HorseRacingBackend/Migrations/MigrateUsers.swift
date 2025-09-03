import Fluent
import Vapor

struct MigrateUsers: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("users")
			.id()
			.field("email", .string, .required)
			.field("first_name", .string, .required)
			.field("last_name", .string, .required)
			.field("is_admin", .bool, .required, .sql(.default(false)))
			.unique(on: "email")
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("users").delete()
	}
}
