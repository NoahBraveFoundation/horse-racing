import Fluent
import Vapor

final class GiftBasketInterest: Model, Content, @unchecked Sendable {
	static let schema = "gift_basket_interests"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "user_id")
	var user: User

	@Field(key: "description")
	var descriptionText: String

	@OptionalParent(key: "cart_id")
	var cart: Cart?

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

	init(id: UUID? = nil, userID: UUID, descriptionText: String) {
		self.id = id
		self.$user.id = userID
		self.descriptionText = descriptionText
	}
}

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
