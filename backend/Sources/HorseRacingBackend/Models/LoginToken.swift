import Fluent
import Vapor

final class LoginToken: Model, Content, @unchecked Sendable {
	static let schema = "login_tokens"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "token")
	var token: String

	@Parent(key: "user_id")
	var user: User

	@Field(key: "expires_at")
	var expiresAt: Date

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

	init(id: UUID? = nil, token: String, userID: UUID, expiresAt: Date) {
		self.id = id
		self.token = token
		self.$user.id = userID
		self.expiresAt = expiresAt
	}
}
