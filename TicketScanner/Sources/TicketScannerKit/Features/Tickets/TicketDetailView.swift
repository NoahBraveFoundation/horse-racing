import ComposableArchitecture
import Foundation
import SwiftUI

public struct TicketDetailView: View {
  @Bindable var store: StoreOf<TicketDetailFeature>

  public init(store: StoreOf<TicketDetailFeature>) {
    self.store = store
  }

  private static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
  }()

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

          NavigationLink(isActive: $store.isSeatEditorActive) {
            if let editorStore = store.scope(
              state: \.seatAssignmentEditor, action: \.seatAssignmentEditor)
            {
              SeatAssignmentEditorView(store: editorStore)
            } else {
              EmptyView()
            }
          } label: {
            LabeledContent("Seat Assignment") {
              Text(seatAssignmentValue(for: entry))
                .foregroundColor(seatAssignmentColor(for: entry))
            }
          }

          if entry.ticket.seatAssignment?.isEmpty ?? true,
            let preference = entry.ticket.seatingPreference,
            !preference.isEmpty
          {
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

      if !store.horses.isEmpty {
        Section("Horses") {
          ForEach(store.horses) { horse in
            VStack(alignment: .leading, spacing: 6) {
              HStack {
                Text(horse.horseName)
                  .font(.headline)
                Spacer()
                HorseStateBadge(state: horse.state)
              }

              Text(horse.ownershipLabel)
                .font(.subheadline)
                .foregroundColor(.secondary)

              Label("Lane \(horse.laneNumber)", systemImage: "flag.checkered")
                .font(.caption)
                .foregroundColor(.secondary)

              Label(horse.roundName, systemImage: "clock")
                .font(.caption)
                .foregroundColor(.secondary)

              if let range = formatRoundRange(for: horse) {
                Text(range)
                  .font(.caption2)
                  .foregroundColor(.secondary)
              }
            }
            .padding(.vertical, 6)
          }
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

  private func formatRoundRange(for horse: TicketDirectoryEntry.Horse) -> String? {
    guard let start = horse.roundStartAt, let end = horse.roundEndAt else {
      return nil
    }

    return "\(Self.timeFormatter.string(from: start)) — \(Self.timeFormatter.string(from: end))"
  }

  private func seatAssignmentValue(for entry: TicketDirectoryEntry) -> String {
    let trimmed = entry.ticket.seatAssignment?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return trimmed.isEmpty ? "Not assigned" : trimmed
  }

  private func seatAssignmentColor(for entry: TicketDirectoryEntry) -> Color {
    let trimmed = entry.ticket.seatAssignment?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return trimmed.isEmpty ? .secondary : .primary
  }
}

private struct HorseStateBadge: View {
  let state: HorseEntryState

  var body: some View {
    Text(state.displayName)
      .font(.caption2)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .foregroundColor(foregroundColor)
      .background(backgroundColor)
      .clipShape(Capsule())
  }

  private var backgroundColor: Color {
    switch state {
    case .confirmed:
      return Color.green.opacity(0.15)
    case .pendingPayment:
      return Color.orange.opacity(0.15)
    case .onHold:
      return Color.red.opacity(0.15)
    }
  }

  private var foregroundColor: Color {
    switch state {
    case .confirmed:
      return .green
    case .pendingPayment:
      return .orange
    case .onHold:
      return .red
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
