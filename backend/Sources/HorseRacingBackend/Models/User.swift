import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
	static let schema = "users"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "email")
	var email: String

	@Field(key: "first_name")
	var firstName: String

	@Field(key: "last_name")
	var lastName: String

	@Field(key: "is_admin")
	var isAdmin: Bool

	@Children(for: \.$owner)
	var tickets: [Ticket]

	@Children(for: \.$owner)
	var horses: [Horse]

	@Children(for: \.$user)
	var sponsorInterests: [SponsorInterest]

	@Children(for: \.$user)
	var giftBasketInterests: [GiftBasketInterest]

	@Children(for: \.$user)
	var payments: [Payment]

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?

	init() { }

	init(id: UUID? = nil, email: String, firstName: String, lastName: String, isAdmin: Bool = false) {
		self.id = id
		self.email = email
		self.firstName = firstName
		self.lastName = lastName
		self.isAdmin = isAdmin
	}
}

extension User: Authenticatable {}
extension User: ModelSessionAuthenticatable {}
