import Fluent
import Vapor

struct MigrateHorsesAddCart: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("horses")
			.field("cart_id", .uuid, .references("carts", "id", onDelete: .setNull))
			.update()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("horses")
			.deleteField("cart_id")
			.update()
	}
}
