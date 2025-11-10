import Fluent
import Vapor

final class TicketScan: Model, Content, @unchecked Sendable {
    static let schema = "ticket_scans"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "ticket_id")
    var ticket: Ticket

    @Parent(key: "scanner_user_id")
    var scanner: User

    @Field(key: "scan_timestamp")
    var scanTimestamp: Date

    @OptionalField(key: "scan_location")
    var scanLocation: String?

    @OptionalField(key: "device_info")
    var deviceInfo: String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, ticketID: UUID, scannerUserID: UUID, scanLocation: String? = nil, deviceInfo: String? = nil) {
        self.id = id
        self.$ticket.id = ticketID
        self.$scanner.id = scannerUserID
        self.scanTimestamp = Date()
        self.scanLocation = scanLocation
        self.deviceInfo = deviceInfo
    }
}

