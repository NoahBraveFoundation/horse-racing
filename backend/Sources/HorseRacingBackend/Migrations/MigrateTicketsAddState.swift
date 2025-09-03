import Fluent
import Vapor

struct MigrateTicketsAddState: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.field("state", .string, .required, .sql(.default("on_hold")))
			.update()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.deleteField("state")
			.update()
	}
}
