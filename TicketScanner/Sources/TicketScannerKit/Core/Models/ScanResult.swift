import Foundation

public struct ScanResult: Equatable, Sendable {
  public let success: Bool
  public let message: String
  public let ticket: Ticket?
  public let alreadyScanned: Bool
  public let previousScan: TicketScan?

  public init(
    success: Bool, message: String, ticket: Ticket?, alreadyScanned: Bool, previousScan: TicketScan?
  ) {
    self.success = success
    self.message = message
    self.ticket = ticket
    self.alreadyScanned = alreadyScanned
    self.previousScan = previousScan
  }
}

public struct ScanTicketResponse: Codable, Sendable, Equatable {
  public let success: Bool
  public let message: String
  public let ticket: Ticket?
  public let alreadyScanned: Bool
  public let previousScan: TicketScan?
}

public struct ScanningStats: Codable, Sendable, Equatable {
  public let totalScanned: Int
  public let totalTickets: Int
  public let recentScans: [TicketScan]
}
