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
      
      // Save the token for future requests
      ApolloClientService.shared.setAuthToken(token)
      
      return User(
        id: UUID(uuidString: userNode.id) ?? UUID(),
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

      // Mock response for now - replace with actual Apollo call
      return ScanTicketResponse(
        success: true,
        message: "Ticket scanned successfully",
        ticket: Ticket(
          id: ticketId,
          attendeeFirst: "John",
          attendeeLast: "Doe",
          seatingPreference: nil,
          seatAssignment: "Table 5, Seat 3",
          state: .confirmed,
          scannedAt: Date(),
          scannedByUserID: UUID(),
          scanLocation: location
        ),
        alreadyScanned: false,
        previousScan: nil
      )
    },

    getScanningStats: {
      // Mock response for now - replace with actual Apollo call
      return ScanningStats(
        totalScanned: 45,
        totalTickets: 100,
        scansByHour: [
          "14:00": 5,
          "15:00": 8,
          "16:00": 12,
          "17:00": 15,
          "18:00": 5,
        ],
        recentScans: []
      )
    },

    getRecentScans: { limit in
      // Mock response for now - replace with actual Apollo call
      return []
    },

    getTicketByBarcode: { barcode in
      // Parse barcode to get ticket ID
      guard barcode.hasPrefix("NBT:") else {
        return nil
      }
      let ticketIdString = String(barcode.dropFirst(4))
      guard let ticketId = UUID(uuidString: ticketIdString) else {
        return nil
      }

      // Mock response for now - replace with actual Apollo call
      return Ticket(
        id: ticketId,
        attendeeFirst: "Jane",
        attendeeLast: "Smith",
        seatingPreference: nil,
        seatAssignment: "Table 3, Seat 1",
        state: .confirmed,
        scannedAt: nil,
        scannedByUserID: nil,
        scanLocation: nil
      )
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
