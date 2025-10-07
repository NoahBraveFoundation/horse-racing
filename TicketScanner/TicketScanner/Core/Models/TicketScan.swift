import Foundation

struct TicketScan: Codable, Identifiable {
    let id: UUID
    let ticket: Ticket
    let scanner: User
    let scanTimestamp: Date
    let scanLocation: String?
    let deviceInfo: String?
    let createdAt: Date?
}

struct User: Codable, Identifiable {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let isAdmin: Bool
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

