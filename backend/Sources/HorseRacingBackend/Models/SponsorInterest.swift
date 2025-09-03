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

	@OptionalField(key: "company_logo_base64")
	var companyLogoBase64: String?

	@OptionalParent(key: "cart_id")
	var cart: Cart?

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	init() {}

	init(id: UUID? = nil, userID: UUID, companyName: String, companyLogoBase64: String? = nil) {
		self.id = id
		self.$user.id = userID
		self.companyName = companyName
		self.companyLogoBase64 = companyLogoBase64
	}
}
