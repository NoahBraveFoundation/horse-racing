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

        @OptionalField(key: "seating_preference")
        var seatingPreference: String?

        @OptionalField(key: "seat_assignment")
        var seatAssignment: String?

        @OptionalParent(key: "cart_id")
        var cart: Cart?

	@Enum(key: "state")
	var state: TicketState

	@Field(key: "can_remove")
	var canRemove: Bool

	@OptionalField(key: "scanned_at")
	var scannedAt: Date?

	@OptionalParent(key: "scanned_by_user_id")
	var scannedBy: User?

	@OptionalField(key: "scan_location")
	var scanLocation: String?

	@Children(for: \.$ticket)
	var scans: [TicketScan]

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

        init(id: UUID? = nil, ownerID: UUID, attendeeFirst: String, attendeeLast: String, seatingPreference: String? = nil, seatAssignment: String? = nil, state: TicketState = .onHold, canRemove: Bool = false) {
                self.id = id
                self.$owner.id = ownerID
                self.attendeeFirst = attendeeFirst
                self.attendeeLast = attendeeLast
                self.seatingPreference = seatingPreference
                self.seatAssignment = seatAssignment
                self.state = state
                self.canRemove = canRemove
        }
}

enum TicketState: String, Codable, CaseIterable {
	case onHold = "on_hold"
	case pendingPayment = "pending_payment"
	case confirmed = "confirmed"
}
