import Foundation

public struct Ticket: Codable, Identifiable, Equatable, Sendable {
  public let id: UUID
  public let attendeeFirst: String
  public let attendeeLast: String
  public let seatingPreference: String?
  public let seatAssignment: String?
  public let state: TicketState
  public let scannedAt: Date?
  public let scannedByUserID: UUID?
  public let scanLocation: String?

  public var attendeeName: String {
    "\(attendeeFirst) \(attendeeLast)"
  }

  public var isScanned: Bool {
    scannedAt != nil
  }

  public var shortCode: String {
    let sanitized = id.uuidString.replacingOccurrences(of: "-", with: "")
    return String(sanitized.prefix(5))
      .uppercased()
  }

  public init(
    id: UUID, attendeeFirst: String, attendeeLast: String, seatingPreference: String? = nil,
    seatAssignment: String? = nil, state: TicketState, scannedAt: Date? = nil,
    scannedByUserID: UUID? = nil, scanLocation: String? = nil
  ) {
    self.id = id
    self.attendeeFirst = attendeeFirst
    self.attendeeLast = attendeeLast
    self.seatingPreference = seatingPreference
    self.seatAssignment = seatAssignment
    self.state = state
    self.scannedAt = scannedAt
    self.scannedByUserID = scannedByUserID
    self.scanLocation = scanLocation
  }
}

public enum TicketState: String, Codable, CaseIterable, Sendable {
  case onHold = "on_hold"
  case pendingPayment = "pending_payment"
  case confirmed = "confirmed"

  public var displayName: String {
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
