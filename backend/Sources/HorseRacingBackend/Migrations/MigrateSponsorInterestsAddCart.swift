import Fluent
import Vapor

struct MigrateSponsorInterestsAddCart: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sponsor_interests")
			.field("cart_id", .uuid, .references("carts", "id", onDelete: .setNull))
			.update()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sponsor_interests")
			.deleteField("cart_id")
			.update()
	}
}
