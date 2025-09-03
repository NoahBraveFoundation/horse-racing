import Fluent
import Vapor

struct MigrateGiftBasketInterestsAddCart: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("gift_basket_interests")
			.field("cart_id", .uuid, .references("carts", "id", onDelete: .setNull))
			.update()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("gift_basket_interests")
			.deleteField("cart_id")
			.update()
	}
}
