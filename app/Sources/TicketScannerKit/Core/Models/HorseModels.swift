import Foundation

public enum HorseEntryState: String, Codable, CaseIterable, Sendable {
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

public struct HorseBoardRound: Equatable, Identifiable, Sendable {
  public let id: UUID
  public let name: String
  public let startAt: Date?
  public let endAt: Date?
  public var lanes: [HorseBoardLane]

  public init(id: UUID, name: String, startAt: Date?, endAt: Date?, lanes: [HorseBoardLane]) {
    self.id = id
    self.name = name
    self.startAt = startAt
    self.endAt = endAt
    self.lanes = lanes.sorted { $0.number < $1.number }
  }
}

public struct HorseBoardLane: Equatable, Identifiable, Sendable {
  public let id: UUID
  public let number: Int
  public let horse: HorseBoardHorse?

  public init(id: UUID, number: Int, horse: HorseBoardHorse?) {
    self.id = id
    self.number = number
    self.horse = horse
  }

  public var isAvailable: Bool {
    horse == nil
  }
}

public struct HorseBoardHorse: Equatable, Identifiable, Sendable {
  public let id: UUID
  public let horseName: String
  public let ownershipLabel: String
  public let state: HorseEntryState
  public let ownerFirstName: String
  public let ownerLastName: String
  public let ownerEmail: String
  public let ownerHasScannedIn: Bool

  public init(
    id: UUID,
    horseName: String,
    ownershipLabel: String,
    state: HorseEntryState,
    ownerFirstName: String,
    ownerLastName: String,
    ownerEmail: String,
    ownerHasScannedIn: Bool
  ) {
    self.id = id
    self.horseName = horseName
    self.ownershipLabel = ownershipLabel
    self.state = state
    self.ownerFirstName = ownerFirstName
    self.ownerLastName = ownerLastName
    self.ownerEmail = ownerEmail
    self.ownerHasScannedIn = ownerHasScannedIn
  }

  public var ownerFullName: String {
    "\(ownerFirstName) \(ownerLastName)"
  }
}
