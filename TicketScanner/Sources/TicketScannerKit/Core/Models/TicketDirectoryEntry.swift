import Foundation

public struct TicketDirectoryEntry: Codable, Equatable, Identifiable, Sendable {
  public let ticket: Ticket
  public let ownerName: String
  public let ownerEmail: String
  public let orderNumber: String?
  public var associatedTickets: [AssociatedTicket] = []

  public var id: UUID { ticket.id }

  public init(
    ticket: Ticket,
    ownerName: String,
    ownerEmail: String,
    orderNumber: String? = nil,
    associatedTickets: [AssociatedTicket] = []
  ) {
    self.ticket = ticket
    self.ownerName = ownerName
    self.ownerEmail = ownerEmail
    self.orderNumber = orderNumber
    self.associatedTickets = associatedTickets
  }

  private enum CodingKeys: String, CodingKey {
    case ticket
    case ownerName
    case ownerEmail
    case orderNumber
    case associatedTickets
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    ticket = try container.decode(Ticket.self, forKey: .ticket)
    ownerName = try container.decode(String.self, forKey: .ownerName)
    ownerEmail = try container.decode(String.self, forKey: .ownerEmail)
    orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber)
    associatedTickets =
      try container.decodeIfPresent(
        [AssociatedTicket].self,
        forKey: .associatedTickets
      ) ?? []
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(ticket, forKey: .ticket)
    try container.encode(ownerName, forKey: .ownerName)
    try container.encode(ownerEmail, forKey: .ownerEmail)
    try container.encodeIfPresent(orderNumber, forKey: .orderNumber)
    if !associatedTickets.isEmpty {
      try container.encode(associatedTickets, forKey: .associatedTickets)
    }
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
      || (orderNumber?.lowercased().contains(lowerQuery) ?? false)
      || (ticket.seatAssignment?.lowercased().contains(lowerQuery) ?? false)
      || ticket.id.uuidString.lowercased().contains(lowerQuery)
      || ticket.shortCode.lowercased().contains(lowerQuery)
      || associatedTickets.contains {
        $0.attendeeName.lowercased().contains(lowerQuery)
          || $0.shortCode.lowercased().contains(lowerQuery)
      }
  }

  public struct AssociatedTicket: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let attendeeFirst: String
    public let attendeeLast: String
    public let scannedAt: Date?

    public init(id: UUID, attendeeFirst: String, attendeeLast: String, scannedAt: Date?) {
      self.id = id
      self.attendeeFirst = attendeeFirst
      self.attendeeLast = attendeeLast
      self.scannedAt = scannedAt
    }

    public var attendeeName: String {
      "\(attendeeFirst) \(attendeeLast)"
    }

    public var isScanned: Bool {
      scannedAt != nil
    }

    public var shortCode: String {
      let sanitized = id.uuidString.replacingOccurrences(of: "-", with: "")
      return String(sanitized.prefix(5)).uppercased()
    }
  }

}
