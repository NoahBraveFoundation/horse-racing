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

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?

	init() { }

	init(id: UUID? = nil, email: String, firstName: String, lastName: String) {
		self.id = id
		self.email = email
		self.firstName = firstName
		self.lastName = lastName
	}
}

extension User: Authenticatable {}
extension User: ModelSessionAuthenticatable {}

struct MigrateUsers: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("users")
			.id()
			.field("email", .string, .required)
			.field("first_name", .string, .required)
			.field("last_name", .string, .required)
			.unique(on: "email")
			.field("created_at", .datetime)
			.field("updated_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("users").delete()
	}
}
