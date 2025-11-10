import Foundation

public struct TicketDirectoryEntry: Equatable, Identifiable, Sendable {
  public let ticket: Ticket
  public let ownerName: String
  public let ownerEmail: String

  public var id: UUID { ticket.id }

  public init(ticket: Ticket, ownerName: String, ownerEmail: String) {
    self.ticket = ticket
    self.ownerName = ownerName
    self.ownerEmail = ownerEmail
  }

  public var attendeeName: String {
    ticket.attendeeName
  }

  public var subtitle: String {
    [ownerName, ownerEmail].joined(separator: " • ")
  }

  public func matches(_ query: String) -> Bool {
    guard !query.isEmpty else { return true }
    let lowerQuery = query.lowercased()
    return attendeeName.lowercased().contains(lowerQuery)
      || ownerName.lowercased().contains(lowerQuery)
      || ownerEmail.lowercased().contains(lowerQuery)
      || (ticket.seatAssignment?.lowercased().contains(lowerQuery) ?? false)
  }
}
