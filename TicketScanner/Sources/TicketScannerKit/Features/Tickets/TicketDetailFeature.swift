import ComposableArchitecture
import Dependencies
import Foundation
import Sharing

@Reducer
public struct TicketDetailFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.appStorage(SharedStorageKey.tickets))
    public var tickets: [TicketDirectoryEntry] = []
    public var ticketID: UUID
    public var scanHistory: [TicketScan] = []
    public var isLoading = false
    public var isManualScanInFlight = false
    public var isUnscanInFlight = false
    public var errorMessage: String?

    public init(ticketID: UUID) {
      self.ticketID = ticketID
    }

    public var entry: TicketDirectoryEntry? {
      tickets.first(where: { $0.id == ticketID })
    }

    public var ticket: Ticket? {
      entry?.ticket
    }

    public var ownerName: String? {
      entry?.ownerName
    }

    public var ownerEmail: String? {
      entry?.ownerEmail
    }

    public var ticketNumberDisplay: String? {
      ticket.map { "#\($0.shortCode)" }
    }

    public var orderNumberDisplay: String? {
      entry?.orderNumber
    }

    public var associatedTickets: [TicketDirectoryEntry.AssociatedTicket] {
      entry?.associatedTickets.sorted {
        $0.attendeeName.localizedCaseInsensitiveCompare($1.attendeeName) == .orderedAscending
      }
        ?? []
    }

    public var horses: [TicketDirectoryEntry.Horse] {
      entry?.horses ?? []
    }
  }

  public enum Action: Equatable {
    case onAppear
    case refresh
    case refreshResponse(TaskResult<[TicketScan]>)
    case manualScanTapped
    case manualScanResponse(TaskResult<ScanTicketResponse>)
    case unscanTapped
    case unscanResponse(TaskResult<ScanTicketResponse>)
    case clearError
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.locationService) var locationService

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        if state.scanHistory.isEmpty {
          return .send(.refresh)
        }
        return .none

      case .refresh:
        guard let entry = state.entry else { return .none }
        state.isLoading = true
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          do {
            let scans = try await apiClient.getRecentScans(100)
              .filter { $0.ticket.id == entry.ticket.id }
              .sorted { $0.scanTimestamp > $1.scanTimestamp }
            await send(.refreshResponse(.success(scans)))
          } catch {
            await send(.refreshResponse(.failure(error)))
          }
        }

      case .refreshResponse(.success(let scans)):
        state.isLoading = false
        state.scanHistory = scans
        return .none

      case .refreshResponse(.failure(let error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none

      case .manualScanTapped:
        guard let ticket = state.ticket else { return .none }
        state.isManualScanInFlight = true
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          @Dependency(\.locationService) var locationService
          do {
            let location = await locationService.currentLocation()
            let barcode = "NBT:\(ticket.id.uuidString)"
            let response = try await apiClient.scanTicket(
              barcode,
              location,
              DeviceInfoProvider.currentDescription()
            )
            await send(.manualScanResponse(.success(response)))
          } catch {
            await send(.manualScanResponse(.failure(error)))
          }
        }

      case .manualScanResponse(.success(let response)):
        state.isManualScanInFlight = false
        guard response.success else {
          state.errorMessage = response.message
          return .none
        }

        if let updatedTicket = response.ticket {
          state.$tickets.withLock { tickets in
            if let index = tickets.firstIndex(where: { $0.id == updatedTicket.id }) {
              let existing = tickets[index]
              tickets[index] = TicketDirectoryEntry(
                ticket: updatedTicket,
                ownerName: existing.ownerName,
                ownerEmail: existing.ownerEmail,
                orderNumber: existing.orderNumber,
                associatedTickets: existing.associatedTickets,
                horses: existing.horses
              )
            }
          }
        }

        return .send(.refresh)

      case .manualScanResponse(.failure(let error)):
        state.isManualScanInFlight = false
        state.errorMessage = error.localizedDescription
        return .none

      case .unscanTapped:
        guard let latestScan = state.scanHistory.first else {
          state.errorMessage = "No scan history is available to undo."
          return .send(.refresh)
        }
        state.isUnscanInFlight = true
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          do {
            let response = try await apiClient.undoScan(latestScan.id.uuidString)
            await send(.unscanResponse(.success(response)))
          } catch {
            await send(.unscanResponse(.failure(error)))
          }
        }

      case .unscanResponse(.success(let response)):
        state.isUnscanInFlight = false
        guard response.success else {
          state.errorMessage = response.message
          return .none
        }

        if let updatedTicket = response.ticket {
          state.$tickets.withLock { tickets in
            if let index = tickets.firstIndex(where: { $0.id == updatedTicket.id }) {
              let existing = tickets[index]
              tickets[index] = TicketDirectoryEntry(
                ticket: updatedTicket,
                ownerName: existing.ownerName,
                ownerEmail: existing.ownerEmail,
                orderNumber: existing.orderNumber,
                associatedTickets: existing.associatedTickets,
                horses: existing.horses
              )
            }
          }
        }

        return .send(.refresh)

      case .unscanResponse(.failure(let error)):
        state.isUnscanInFlight = false
        state.errorMessage = error.localizedDescription
        return .none

      case .clearError:
        state.errorMessage = nil
        return .none
      }
    }
  }
}
