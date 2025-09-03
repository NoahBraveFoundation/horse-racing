import Fluent
import Vapor

final class Round: Model, Content, @unchecked Sendable {
	static let schema = "rounds"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "name")
	var name: String

	@Field(key: "start_at")
	var startAt: Date

	@Field(key: "end_at")
	var endAt: Date

	@Children(for: \.$round)
	var lanes: [Lane]

	@Children(for: \.$round)
	var horses: [Horse]

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

	init(id: UUID? = nil, name: String, startAt: Date, endAt: Date) {
		self.id = id
		self.name = name
		self.startAt = startAt
		self.endAt = endAt
	}
}
