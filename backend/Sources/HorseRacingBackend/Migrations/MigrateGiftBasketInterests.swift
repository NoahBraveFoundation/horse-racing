import Fluent
import Vapor

struct MigrateGiftBasketInterests: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("gift_basket_interests")
			.id()
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("description", .string, .required)
			.field("created_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("gift_basket_interests").delete()
	}
}
