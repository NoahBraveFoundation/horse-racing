import ComposableArchitecture
import SwiftUI

public struct TicketDetailView: View {
  @Bindable var store: StoreOf<TicketDetailFeature>

  public init(store: StoreOf<TicketDetailFeature>) {
    self.store = store
  }

  public var body: some View {
    List {
      if let entry = store.entry {
        Section("Ticket") {
          LabeledContent("Attendee", value: entry.attendeeName)

          if let ticketNumber = store.ticketNumberDisplay {
            LabeledContent("Ticket Number", value: ticketNumber)
          }

          if let orderNumber = store.orderNumberDisplay {
            LabeledContent("Order", value: orderNumber)
          }

          LabeledContent("Status") {
            HStack(spacing: 8) {
              Text(entry.ticket.state.displayName)
              if entry.ticket.isScanned {
                Image(systemName: "checkmark.seal.fill")
                  .foregroundColor(.green)
              }
            }
          }

          if let seat = entry.ticket.seatAssignment, !seat.isEmpty {
            LabeledContent("Seat", value: seat)
          } else if let preference = entry.ticket.seatingPreference, !preference.isEmpty {
            LabeledContent("Preference", value: preference)
          }

          if let scannedAt = entry.ticket.scannedAt {
            LabeledContent("Last Scan") {
              VStack(alignment: .trailing, spacing: 2) {
                Text(scannedAt.formatted(date: .abbreviated, time: .shortened))
                if let location = entry.ticket.scanLocation {
                  Text(location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
              }
            }
          } else {
            LabeledContent("Last Scan", value: "Not yet scanned")
          }
        }

        Section("Owner") {
          LabeledContent("Name", value: entry.ownerName)
          LabeledContent("Email", value: entry.ownerEmail)
        }
      }

      Section("Scan History") {
        if store.isLoading && store.scanHistory.isEmpty {
          ProgressView()
            .frame(maxWidth: .infinity)
        } else if store.scanHistory.isEmpty {
          ContentUnavailableView(
            "No scans recorded",
            systemImage: "clock.badge.questionmark"
          )
        } else {
          ForEach(store.scanHistory) { scan in
            VStack(alignment: .leading, spacing: 4) {
              Text(scan.scanTimestamp.formatted(date: .abbreviated, time: .shortened))
                .font(.headline)

              Text("Scanned by \(scan.scanner.fullName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

              if let location = scan.scanLocation, !location.isEmpty {
                Label(location, systemImage: "mappin.and.ellipse")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
            .padding(.vertical, 4)
          }
        }
      }

      if !store.associatedTickets.isEmpty {
        Section("Associated Tickets") {
          ForEach(store.associatedTickets) { ticket in
            VStack(alignment: .leading, spacing: 4) {
              HStack {
                Text(ticket.attendeeName)
                  .font(.headline)
                Spacer()
                Text("#\(ticket.shortCode)")
                  .font(.subheadline)
                  .foregroundColor(.secondary)
              }

              if ticket.isScanned {
                Label("Scanned", systemImage: "checkmark.seal.fill")
                  .font(.caption)
                  .foregroundColor(.green)
                if let scannedAt = ticket.scannedAt {
                  Text(scannedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
              } else {
                Label("Not scanned", systemImage: "barcode.viewfinder")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
            .padding(.vertical, 4)
          }
        }
      }
    }
    .navigationTitle(store.entry?.attendeeName ?? "Ticket")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        if store.isManualScanInFlight || store.isUnscanInFlight {
          ProgressView()
        } else {
          if store.ticket?.isScanned == true {
            Button("Unscan") {
              store.send(.unscanTapped)
            }
            .disabled(store.scanHistory.isEmpty)
          } else {
            Button("Scan") {
              store.send(.manualScanTapped)
            }
          }
        }
      }
    }
    .refreshable {
      await store.send(.refresh).finish()
    }
    .task {
      await store.send(.onAppear).finish()
    }
    .alert("Error", isPresented: .constant(store.errorMessage != nil)) {
      Button("OK") {
        store.send(.clearError)
      }
    } message: {
      Text(store.errorMessage ?? "")
    }
  }
}

#Preview {
  NavigationStack {
    TicketDetailView(
      store: Store(
        initialState: TicketDetailFeature.State(ticketID: UUID())
      ) {
        TicketDetailFeature()
      }
    )
  }
}
