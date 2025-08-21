import Fluent
import Vapor

final class Race: Model, @unchecked Sendable {
    static let schema = "races"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "date")
    var date: Date

    @Field(key: "distance")
    var distance: Int // in meters

    @Field(key: "status")
    var status: RaceStatus

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, name: String, date: Date, distance: Int, status: RaceStatus = .upcoming) {
        self.id = id
        self.name = name
        self.date = date
        self.distance = distance
        self.status = status
    }
}

enum RaceStatus: String, Codable, CaseIterable {
    case upcoming = "UPCOMING"
    case inProgress = "IN_PROGRESS"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

struct MigrateRaces: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("races")
            .id()
            .field("name", .string, .required)
            .field("date", .datetime, .required)
            .field("distance", .int, .required)
            .field("status", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("races").delete()
    }
}
