import Fluent
import Vapor

struct MigrateTicketsAddCart: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.field("cart_id", .uuid, .references("carts", "id", onDelete: .setNull))
			.update()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.deleteField("cart_id")
			.update()
	}
}
