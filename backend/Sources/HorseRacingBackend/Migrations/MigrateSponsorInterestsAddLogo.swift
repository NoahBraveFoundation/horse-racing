import Fluent
import Vapor

struct MigrateSponsorInterestsAddLogo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("sponsor_interests")
            .field("company_logo_base64", .string)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("sponsor_interests")
            .deleteField("company_logo_base64")
            .update()
    }
}
