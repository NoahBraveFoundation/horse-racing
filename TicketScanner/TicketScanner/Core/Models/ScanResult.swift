import Foundation

struct ScanResult: Equatable {
    let success: Bool
    let message: String
    let ticket: Ticket?
    let alreadyScanned: Bool
    let previousScan: TicketScan?
}

struct ScanTicketResponse: Codable {
    let success: Bool
    let message: String
    let ticket: Ticket?
    let alreadyScanned: Bool
    let previousScan: TicketScan?
}

struct ScanningStats: Codable {
    let totalScanned: Int
    let totalTickets: Int
    let scansByHour: [String: Int]
    let recentScans: [TicketScan]
}

