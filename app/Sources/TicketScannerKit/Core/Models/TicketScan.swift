import Foundation

public struct TicketScan: Codable, Identifiable, Sendable, Equatable {
  public let id: UUID
  public let ticket: Ticket
  public let scanner: User
  public let scanTimestamp: Date
  public let scanLocation: String?
  public let deviceInfo: String?
  public let createdAt: Date?

  public init(
    id: UUID, ticket: Ticket, scanner: User, scanTimestamp: Date, scanLocation: String? = nil,
    deviceInfo: String? = nil, createdAt: Date? = nil
  ) {
    self.id = id
    self.ticket = ticket
    self.scanner = scanner
    self.scanTimestamp = scanTimestamp
    self.scanLocation = scanLocation
    self.deviceInfo = deviceInfo
    self.createdAt = createdAt
  }
}

public struct User: Codable, Identifiable, Sendable, Equatable {
  public let id: UUID
  public let email: String
  public let firstName: String
  public let lastName: String
  public let isAdmin: Bool

  public var fullName: String {
    "\(firstName) \(lastName)"
  }

  public init(id: UUID, email: String, firstName: String, lastName: String, isAdmin: Bool) {
    self.id = id
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.isAdmin = isAdmin
  }
}
