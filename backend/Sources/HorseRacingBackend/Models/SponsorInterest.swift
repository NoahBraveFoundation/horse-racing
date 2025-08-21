import Fluent
import Vapor

final class SponsorInterest: Model, Content, @unchecked Sendable {
	static let schema = "sponsor_interests"

	@ID(key: .id)
	var id: UUID?

	@Parent(key: "user_id")
	var user: User

	@Field(key: "company_name")
	var companyName: String

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

	init(id: UUID? = nil, userID: UUID, companyName: String) {
		self.id = id
		self.$user.id = userID
		self.companyName = companyName
	}
}

struct MigrateSponsorInterests: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sponsor_interests")
			.id()
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.field("company_name", .string, .required)
			.field("created_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("sponsor_interests").delete()
	}
}
