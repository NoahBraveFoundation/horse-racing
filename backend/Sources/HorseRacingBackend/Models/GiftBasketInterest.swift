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
