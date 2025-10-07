import Dependencies
import Apollo
import ApolloAPI
import Foundation

@DependencyClient
struct APIClient {
    var login: @Sendable (String, String) async throws -> User
    var scanTicket: @Sendable (String, String?, String?) async throws -> ScanTicketResponse
    var getScanningStats: @Sendable () async throws -> ScanningStats
    var getRecentScans: @Sendable (Int) async throws -> [TicketScan]
    var getTicketByBarcode: @Sendable (String) async throws -> Ticket?
}

extension APIClient: DependencyKey {
    static let liveValue = APIClient(
        login: { email, password in
            // For now, return a mock user - in real implementation, you'd use Apollo
            return User(
                id: UUID(),
                email: email,
                firstName: "Admin",
                lastName: "User",
                isAdmin: true
            )
        },
        
        scanTicket: { barcode, location, deviceInfo in
            // Parse barcode to get ticket ID
            guard barcode.hasPrefix("NBT:"),
                  let ticketIdString = barcode.dropFirst(4),
                  let ticketId = UUID(uuidString: String(ticketIdString)) else {
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
                    "18:00": 5
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
            guard barcode.hasPrefix("NBT:"),
                  let ticketIdString = barcode.dropFirst(4),
                  let ticketId = UUID(uuidString: String(ticketIdString)) else {
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