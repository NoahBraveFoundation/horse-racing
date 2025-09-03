import Fluent
import Vapor

struct MigrateRounds: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("rounds")
			.id()
			.field("name", .string, .required)
			.field("start_at", .datetime, .required)
			.field("end_at", .datetime, .required)
			.field("created_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("rounds").delete()
	}
}
