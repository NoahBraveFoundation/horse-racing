import Fluent
import Vapor

enum HorseEntryState: String, Codable, CaseIterable {
	case onHold = "on_hold"
	case pendingPayment = "pending_payment"
	case confirmed = "confirmed"
}

final class Horse: Model, Content, @unchecked Sendable {
	static let schema = "horses"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "owner_id")
	var owner: User

	@Parent(key: "round_id")
	var round: Round

	@Parent(key: "lane_id")
	var lane: Lane

	@Field(key: "horse_name")
	var horseName: String

	@Field(key: "ownership_label")
	var ownershipLabel: String

	@Enum(key: "state")
	var state: HorseEntryState

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?

	init() {}

	init(id: UUID? = nil, ownerID: UUID, roundID: UUID, laneID: UUID, horseName: String, ownershipLabel: String, state: HorseEntryState) {
		self.id = id
		self.$owner.id = ownerID
		self.$round.id = roundID
		self.$lane.id = laneID
		self.horseName = horseName
		self.ownershipLabel = ownershipLabel
		self.state = state
	}
}

struct MigrateHorses: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("horses")
			.id()
			.field("owner_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("round_id", .uuid, .required, .references("rounds", "id", onDelete: .cascade))
			.field("lane_id", .uuid, .required, .references("lanes", "id", onDelete: .cascade))
			.field("horse_name", .string, .required)
			.field("ownership_label", .string, .required)
			.field("state", .string, .required)
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.unique(on: "owner_id", "round_id")
			.unique(on: "lane_id")
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("horses").delete()
	}
}
