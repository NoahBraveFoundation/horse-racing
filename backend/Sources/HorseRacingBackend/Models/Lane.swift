import Fluent
import Vapor

final class Lane: Model, Content, @unchecked Sendable {
	static let schema = "lanes"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "round_id")
	var round: Round

	@Field(key: "number")
	var number: Int

	@OptionalChild(for: \.$lane)
	var horse: Horse?

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

	init(id: UUID? = nil, roundID: UUID, number: Int) {
		self.id = id
		self.$round.id = roundID
		self.number = number
	}
}
