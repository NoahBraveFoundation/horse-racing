import Fluent
import Vapor

final class Ticket: Model, Content, @unchecked Sendable {
	static let schema = "tickets"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "user_id")
	var owner: User

	@Field(key: "attendee_first")
	var attendeeFirst: String

	@Field(key: "attendee_last")
	var attendeeLast: String

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

	init(id: UUID? = nil, ownerID: UUID, attendeeFirst: String, attendeeLast: String) {
		self.id = id
		self.$owner.id = ownerID
		self.attendeeFirst = attendeeFirst
		self.attendeeLast = attendeeLast
	}
}

struct MigrateTickets: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.id()
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("attendee_first", .string, .required)
			.field("attendee_last", .string, .required)
			.field("created_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets").delete()
	}
}
