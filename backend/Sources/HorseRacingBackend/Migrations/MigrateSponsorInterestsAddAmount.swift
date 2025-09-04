import Fluent
import Vapor

struct MigrateSponsorInterestsAddAmount: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("sponsor_interests")
            .field("amount_cents", .int, .required, .sql(.default(10000)))
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("sponsor_interests")
            .deleteField("amount_cents")
            .update()
    }
}
