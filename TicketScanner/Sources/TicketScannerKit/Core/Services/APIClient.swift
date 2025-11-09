import Apollo
import ApolloAPI
import Dependencies
import Foundation
import HorseRacingAPI

struct APIClient {
  var sendMagicLink: @Sendable (String) async throws -> Void
  var validateToken: @Sendable (String) async throws -> User
  var scanTicket: @Sendable (String, String?, String?) async throws -> ScanTicketResponse
  var getScanningStats: @Sendable () async throws -> ScanningStats
  var getRecentScans: @Sendable (Int) async throws -> [TicketScan]
  var getTicketByBarcode: @Sendable (String) async throws -> Ticket?
}

extension APIClient: DependencyKey {
  static let liveValue = APIClient(
    sendMagicLink: { email in
      let mutation = LoginMutation(
        email: email,
        redirectTo: .some("ticketscanner://auth-callback")
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

      // Save the token for future requests
      ApolloClientService.shared.setAuthToken(token)

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

      guard result.scanTicket.success else {
        throw APIClientError.graphQLError(result.scanTicket.message)
      }

      // Convert GraphQL response to our local models
      let ticket = result.scanTicket.ticket?.toLocal()
      let previousScan = result.scanTicket.previousScan?.toLocal()

      return ScanTicketResponse(
        success: result.scanTicket.success,
        message: result.scanTicket.message,
        ticket: ticket,
        alreadyScanned: result.scanTicket.alreadyScanned,
        previousScan: previousScan
      )
    },

    getScanningStats: {
      let query = ScanningStatsQuery()

      let result = try await ApolloClientService.shared.fetch(query: query)

      let recentScans = result.scanningStats.recentScans.compactMap { $0.toLocal() }

      return ScanningStats(
        totalScanned: result.scanningStats.totalScanned,
        totalTickets: result.scanningStats.totalTickets,
        recentScans: recentScans
      )
    },

    getRecentScans: { limit in
      let query = RecentScansQuery(limit: limit)

      let result = try await ApolloClientService.shared.fetch(query: query)

      return result.recentScans.compactMap { $0.toLocal() }
    },

    getTicketByBarcode: { barcode in
      let query = TicketByBarcodeQuery(barcode: barcode)

      let result = try await ApolloClientService.shared.fetch(query: query)

      return result.ticketByBarcode?.toLocal()
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
      scannedAt: scannedAt.map { Date(timeIntervalSince1970: Double($0) ?? 0) },
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
          let scanner = scanner.fragments.userFragment.toLocal() else {
      return nil
    }
    
    return TicketScan(
      id: scanUUID,
      ticket: ticket,
      scanner: scanner,
      scanTimestamp: Date(timeIntervalSince1970: Double(scanTimestamp) ?? 0),
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
