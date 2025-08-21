import Fluent
import Vapor

final class Horse: Model, @unchecked Sendable {
    static let schema = "horses"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "breed")
    var breed: String

    @Field(key: "age")
    var age: Int

    @Field(key: "jockey")
    var jockey: String

    @Field(key: "odds")
    var odds: Double

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, name: String, breed: String, age: Int, jockey: String, odds: Double) {
        self.id = id
        self.name = name
        self.breed = breed
        self.age = age
        self.jockey = jockey
        self.odds = odds
    }
}

struct MigrateHorses: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("horses")
            .id()
            .field("name", .string, .required)
            .field("breed", .string, .required)
            .field("age", .int, .required)
            .field("jockey", .string, .required)
            .field("odds", .double, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("horses").delete()
    }
}
