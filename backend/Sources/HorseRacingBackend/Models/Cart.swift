import Fluent
import Vapor

enum CartStatus: String, Codable, CaseIterable {
	case open
	case checkedOut
	case abandoned
}

final class Cart: Model, Content, @unchecked Sendable {
	static let schema = "carts"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "user_id")
	var user: User

	@Enum(key: "status")
	var status: CartStatus

	@Children(for: \.$cart)
	var horses: [Horse]

	@Children(for: \.$cart)
	var tickets: [Ticket]

	@Children(for: \.$cart)
	var sponsorInterests: [SponsorInterest]

	@Children(for: \.$cart)
	var giftBasketInterests: [GiftBasketInterest]

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?

	init() {}

	init(id: UUID? = nil, userID: UUID, status: CartStatus = .open) {
		self.id = id
		self.$user.id = userID
		self.status = status
	}
	
	// MARK: - Computed Properties
	
	/// Generate order number from cart ID
	var orderNumber: String {
		guard let id = self.id else { return "NB-0000" }
		let idString = id.uuidString.replacingOccurrences(of: "-", with: "")
		let shortId = String(idString.prefix(8)).uppercased()
		return "NB-\(shortId)"
	}

	var venmoUser: String {
		return VenmoLinkService.venmoUser
	}
}

struct MigrateCarts: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("carts")
			.id()
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("status", .string, .required)
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("carts").delete()
	}
}




