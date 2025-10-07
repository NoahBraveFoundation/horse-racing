import Foundation

struct Ticket: Codable, Identifiable, Equatable {
    let id: UUID
    let attendeeFirst: String
    let attendeeLast: String
    let seatingPreference: String?
    let seatAssignment: String?
    let state: TicketState
    let scannedAt: Date?
    let scannedByUserID: UUID?
    let scanLocation: String?
    
    var attendeeName: String {
        "\(attendeeFirst) \(attendeeLast)"
    }
    
    var isScanned: Bool {
        scannedAt != nil
    }
}

enum TicketState: String, Codable, CaseIterable {
    case onHold = "on_hold"
    case pendingPayment = "pending_payment"
    case confirmed = "confirmed"
    
    var displayName: String {
        switch self {
        case .onHold:
            return "On Hold"
        case .pendingPayment:
            return "Pending Payment"
        case .confirmed:
            return "Confirmed"
        }
    }
}

