import Fluent
import Vapor

final class Payment: Model, Content, @unchecked Sendable {
	static let schema = "payments"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "user_id")
	var user: User

	@Field(key: "total_cents")
	var totalCents: Int

	@Field(key: "payment_received")
	var paymentReceived: Bool

	@Field(key: "payment_received_at")
	var paymentReceivedAt: Date?

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?

	init() {}

	init(id: UUID? = nil, userID: UUID, totalCents: Int, paymentReceived: Bool = false, paymentReceivedAt: Date? = nil) {
		self.id = id
		self.$user.id = userID
		self.totalCents = totalCents
		self.paymentReceived = paymentReceived
		self.paymentReceivedAt = paymentReceivedAt
	}
}
