import Apollo
import ApolloAPI
import Dependencies
import Foundation
import HorseRacingAPI

struct APIClient {
  var sendMagicLink: @Sendable (String) async throws -> Void
  var validateToken: @Sendable (String) async throws -> User
  var scanTicket: @Sendable (String, String?, String?) async throws -> ScanTicketResponse
  var undoScan: @Sendable (HorseRacingAPI.UUID) async throws -> ScanTicketResponse
  var getScanningStats: @Sendable () async throws -> ScanningStats
  var getRecentScans: @Sendable (Int) async throws -> [TicketScan]
  var getTicketByBarcode: @Sendable (String) async throws -> Ticket?
  var getAllTickets: @Sendable () async throws -> [TicketDirectoryEntry]
  var requestHorseAudio: @Sendable (Foundation.UUID) async throws -> HorseAudioClip
}

extension APIClient: DependencyKey {
  static let liveValue = APIClient(
    sendMagicLink: { email in
      let mutation = LoginMutation(
        email: email,
        redirectTo: .null
      )

      let result = try await ApolloClientService.shared.perform(mutation: mutation)

      guard result.login.success else {
        throw APIClientError.graphQLError(result.login.message)
      }
    },

    validateToken: { token in
      let mutation = ValidateTokenMutation(token: token)

      let result = try await ApolloClientService.shared.perform(mutation: mutation)

      guard result.validateToken.success else {
        throw APIClientError.graphQLError(result.validateToken.message)
      }

      guard let userNode = result.validateToken.user else {
        throw APIClientError.authenticationFailed
      }

      guard let idString = userNode.id, let id = UUID(uuidString: idString) else {
        throw APIClientError.invalidResponse
      }

      return User(
        id: id,
        email: userNode.email,
        firstName: userNode.firstName,
        lastName: userNode.lastName,
        isAdmin: userNode.isAdmin
      )
    },

    scanTicket: { barcode, location, deviceInfo in
      // Parse barcode to get ticket ID
      guard barcode.hasPrefix("NBT:") else {
        throw APIClientError.invalidBarcode
      }
      let ticketIdString = String(barcode.dropFirst(4))
      guard let ticketId = UUID(uuidString: ticketIdString) else {
        throw APIClientError.invalidBarcode
      }

      let mutation = ScanTicketMutation(
        ticketId: ticketIdString,
        scanLocation: location.map { .some($0) } ?? .null,
        deviceInfo: deviceInfo.map { .some($0) } ?? .null
      )

      let result = try await ApolloClientService.shared.perform(mutation: mutation)

      let payload = result.scanTicket

      // Convert GraphQL response to our local models
      let ticket = payload.ticket?.toLocal()
      let previousScan = payload.previousScan?.toLocal()

      return ScanTicketResponse(
        success: payload.success,
        message: payload.message,
        ticket: ticket,
        alreadyScanned: payload.alreadyScanned,
        previousScan: previousScan
      )
    },

    undoScan: { scanId in
      let mutation = UndoScanMutation(scanId: scanId)
      let result = try await ApolloClientService.shared.perform(mutation: mutation)
      let payload = result.undoScan

      let ticket = payload.ticket?.fragments.ticketFragment.toLocal()
      let previousScan = payload.previousScan?.fragments.ticketScanFragment.toLocal()

      return ScanTicketResponse(
        success: payload.success,
        message: payload.message,
        ticket: ticket,
        alreadyScanned: payload.alreadyScanned,
        previousScan: previousScan
      )
    },

    getScanningStats: {
      let query = ScanningStatsQuery()

      let result = try await ApolloClientService.shared.fetch(
        query: query,
        cachePolicy: .fetchIgnoringCacheData
      )

      let recentScans = result.scanningStats.recentScans
        .compactMap { $0.toLocal() }
        .sorted { $0.scanTimestamp > $1.scanTimestamp }

      return ScanningStats(
        totalScanned: result.scanningStats.totalScanned,
        totalTickets: result.scanningStats.totalTickets,
        recentScans: recentScans
      )
    },

    getRecentScans: { limit in
      let query = RecentScansQuery(limit: limit)

      let result = try await ApolloClientService.shared.fetch(
        query: query,
        cachePolicy: .fetchIgnoringCacheData
      )

      return result.recentScans
        .compactMap { $0.toLocal() }
        .sorted { $0.scanTimestamp > $1.scanTimestamp }
    },

    getTicketByBarcode: { barcode in
      let query = TicketByBarcodeQuery(barcode: barcode)

      let result = try await ApolloClientService.shared.fetch(query: query)

      return result.ticketByBarcode?.toLocal()
    },

    getAllTickets: {
      let query = AllTicketsQuery()
      let result = try await ApolloClientService.shared.fetch(query: query)
      return result.allTickets.compactMap { selection in
        selection.fragments.ticketDirectoryFragment.toDirectoryEntry()
      }
    },

    requestHorseAudio: { ticketId in
      let mutation = RequestHorseAudioMutation(ticketId: ticketId.uuidString)
      let result = try await ApolloClientService.shared.perform(mutation: mutation)
      let fragment = result.requestHorseAudio.fragments.horseAudioClipFragment
      guard let clip = fragment.toLocal() else {
        throw APIClientError.invalidResponse
      }
      return clip
    }
  )
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

// MARK: - Supporting Types

enum APIClientError: Error, LocalizedError {
  case invalidResponse
  case graphQLError(String)
  case authenticationFailed
  case invalidBarcode

  var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid response from server"
    case .graphQLError(let message):
      return message
    case .authenticationFailed:
      return "Authentication failed"
    case .invalidBarcode:
      return "Invalid barcode format"
    }
  }
}

// MARK: - Date Parsing

private enum APIDateParser {
  private static let appleReferenceEpochOffset: Double = 978_307_200

  static func parse(_ rawValue: String?) -> Foundation.Date? {
    guard let rawValue, !rawValue.isEmpty else { return nil }

    if let numeric = Double(rawValue) {
      return parse(numeric: numeric)
    }

    if let date = makeISOFormatter(fractionalSeconds: true).date(from: rawValue) {
      return date
    }

    if let date = makeISOFormatter(fractionalSeconds: false).date(from: rawValue) {
      return date
    }

    return nil
  }

  static func parse(secondsSinceEpoch rawValue: Double?) -> Foundation.Date? {
    guard let rawValue else { return nil }
    return parse(numeric: rawValue)
  }

  private static func parse(numeric: Double) -> Foundation.Date {
    if numeric > 1_000_000_000_000 {
      // Milliseconds since 1970.
      return Foundation.Date(timeIntervalSince1970: numeric / 1_000)
    } else if numeric >= appleReferenceEpochOffset {
      // Seconds since 1970.
      return Foundation.Date(timeIntervalSince1970: numeric)
    } else {
      // Seconds since Apple's reference date (Jan 1, 2001).
      return Foundation.Date(timeIntervalSince1970: numeric + appleReferenceEpochOffset)
    }
  }

  private static func makeISOFormatter(fractionalSeconds: Bool) -> ISO8601DateFormatter {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions =
      fractionalSeconds
      ? [.withInternetDateTime, .withFractionalSeconds]
      : [.withInternetDateTime]
    return formatter
  }
}

// MARK: - GraphQL Fragment Conversions

extension TicketFragment {
  func toLocal() -> Ticket? {
    guard let idStr = id, let uuid = UUID(uuidString: idStr) else {
      return nil
    }

    let ticketState: TicketState
    switch state.value {
    case .onHold:
      ticketState = .onHold
    case .pendingPayment:
      ticketState = .pendingPayment
    case .confirmed:
      ticketState = .confirmed
    case .none:
      ticketState = .pendingPayment
    @unknown default:
      ticketState = .confirmed
    }

    return Ticket(
      id: uuid,
      attendeeFirst: attendeeFirst,
      attendeeLast: attendeeLast,
      seatingPreference: seatingPreference,
      seatAssignment: seatAssignment,
      state: ticketState,
      scannedAt: APIDateParser.parse(scannedAt),
      scannedByUserID: nil,
      scanLocation: scanLocation
    )
  }
}

extension UserFragment {
  func toLocal() -> User? {
    guard let idStr = id, let uuid = UUID(uuidString: idStr) else {
      return nil
    }
    return User(
      id: uuid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      isAdmin: isAdmin
    )
  }
}

extension TicketScanFragment {
  func toLocal() -> TicketScan? {
    guard let scanIdStr = id, let scanUUID = UUID(uuidString: scanIdStr),
      let ticket = ticket.fragments.ticketFragment.toLocal(),
      let scanner = scanner.fragments.userFragment.toLocal()
    else {
      return nil
    }

    return TicketScan(
      id: scanUUID,
      ticket: ticket,
      scanner: scanner,
      scanTimestamp: APIDateParser.parse(scanTimestamp) ?? Foundation.Date(),
      scanLocation: scanLocation
    )
  }
}

// MARK: - Query/Mutation Result Conversions

extension ScanTicketMutation.Data.ScanTicket.Ticket {
  func toLocal() -> Ticket? {
    fragments.ticketFragment.toLocal()
  }
}

extension ScanTicketMutation.Data.ScanTicket.PreviousScan {
  func toLocal() -> TicketScan? {
    fragments.ticketScanFragment.toLocal()
  }
}

extension ScanningStatsQuery.Data.ScanningStats.RecentScan {
  func toLocal() -> TicketScan? {
    fragments.ticketScanFragment.toLocal()
  }
}

extension RecentScansQuery.Data.RecentScan {
  func toLocal() -> TicketScan? {
    fragments.ticketScanFragment.toLocal()
  }
}

extension TicketByBarcodeQuery.Data.TicketByBarcode {
  func toLocal() -> Ticket? {
    fragments.ticketFragment.toLocal()
  }
}

extension TicketDirectoryFragment {
  func toDirectoryEntry() -> TicketDirectoryEntry? {
    guard let ticket = fragments.ticketFragment.toLocal() else { return nil }
    let ownerName = "\(owner.firstName) \(owner.lastName)"
    let orderNumber = cart?.orderNumber
    let associatedTickets =
      cart?.tickets
      .compactMap { $0.toAssociatedTicket() }
      .filter { $0.id != ticket.id } ?? []

    return TicketDirectoryEntry(
      ticket: ticket,
      ownerName: ownerName,
      ownerEmail: owner.email,
      orderNumber: orderNumber,
      associatedTickets: associatedTickets
    )
  }
}

extension TicketDirectoryFragment.Cart.Ticket {
  fileprivate func toAssociatedTicket() -> TicketDirectoryEntry.AssociatedTicket? {
    guard let idStr = id, let uuid = UUID(uuidString: idStr) else {
      return nil
    }

    return TicketDirectoryEntry.AssociatedTicket(
      id: uuid,
      attendeeFirst: attendeeFirst,
      attendeeLast: attendeeLast,
      scannedAt: APIDateParser.parse(scannedAt)
    )
  }
}

extension HorseAudioClipFragment {
  func toLocal() -> HorseAudioClip? {
    HorseAudioClip(
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      ticketAttendeeName: ticketAttendeeName,
      horseNames: horseNames,
      audioBase64: audioBase64,
      prompt: prompt
    )
  }
}
