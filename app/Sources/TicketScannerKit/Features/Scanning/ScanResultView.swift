import ComposableArchitecture
import SwiftUI

public struct ScanResultView: View {
  @Bindable var store: StoreOf<ScanResultFeature>

  public init(store: StoreOf<ScanResultFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      List {
        Section {
          VStack(spacing: 12) {
            if store.isLoading {
              ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.2)

              Text(store.result.message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            } else {
              Image(
                systemName: store.result.success ? "checkmark.circle.fill" : "xmark.circle.fill"
              )
              .font(.system(size: 56))
              .foregroundColor(store.result.success ? .green : .red)

              Text(store.result.message)
                .font(.headline)
                .foregroundColor(store.result.success ? .primary : .red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            }
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 12)
        }

        if !store.isLoading, let ticket = store.result.ticket {
          Section("Ticket") {
            LabeledContent("Attendee", value: ticket.attendeeName)

            LabeledContent("Ticket Number", value: "#\(ticket.shortCode)")

            LabeledContent("Status") {
              HStack(spacing: 8) {
                Text(ticket.state.displayName)
                if ticket.isScanned {
                  Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                }
              }
            }

            LabeledContent("Seat Assignment") {
              Text(seatAssignmentValue(for: ticket))
                .foregroundColor(seatAssignmentColor(for: ticket))
            }

            if ticket.seatAssignment?.isEmpty ?? true,
              let preference = ticket.seatingPreference,
              !preference.isEmpty
            {
              LabeledContent("Preference", value: preference)
            }
          }
        }

        if !store.isLoading, !store.horses.isEmpty {
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
              .padding(.vertical, 4)
            }
          }
        }

        if !store.isLoading, store.result.alreadyScanned,
          let previousScan = store.result.previousScan
        {
          Section("Previous Scan") {
            LabeledContent("Scanned by", value: previousScan.scanner.fullName)
            LabeledContent("Time") {
              Text(previousScan.scanTimestamp.formatted(date: .abbreviated, time: .shortened))
            }

            if let location = previousScan.scanLocation, !location.isEmpty {
              LabeledContent("Location") {
                Text(location)
              }
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Scan Result")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          if !store.isLoading {
            Button("Done") {
              store.send(.doneButtonTapped)
            }
          }
        }
      }
    }
  }

  private func seatAssignmentValue(for ticket: Ticket) -> String {
    let trimmed = ticket.seatAssignment?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return trimmed.isEmpty ? "Not assigned" : trimmed
  }

  private func seatAssignmentColor(for ticket: Ticket) -> Color {
    let trimmed = ticket.seatAssignment?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return trimmed.isEmpty ? .secondary : .primary
  }

  private func formatRoundRange(for horse: TicketDirectoryEntry.Horse) -> String? {
    guard let start = horse.roundStartAt, let end = horse.roundEndAt else {
      return nil
    }

    return Self.timeFormatter.string(from: start)
      .appending(" — ")
      .appending(Self.timeFormatter.string(from: end))
  }

  private static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
  }()
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
  ScanResultView(
    store: Store(
      initialState: ScanResultFeature.State(
        result: ScanResult(
          success: true,
          message: "Ticket scanned successfully",
          ticket: Ticket(
            id: UUID(),
            attendeeFirst: "John",
            attendeeLast: "Doe",
            seatingPreference: "Near stage",
            seatAssignment: "Table 5, Seat 3",
            state: .confirmed,
            scannedAt: Date(),
            scannedByUserID: UUID(),
            scanLocation: "Main Entrance"
          ),
          alreadyScanned: true,
          previousScan: TicketScan(
            id: UUID(),
            ticket: Ticket(
              id: UUID(),
              attendeeFirst: "John",
              attendeeLast: "Doe",
              state: .confirmed
            ),
            scanner: User(
              id: UUID(),
              email: "scanner@example.com",
              firstName: "Sam",
              lastName: "Scanner",
              isAdmin: true
            ),
            scanTimestamp: Date().addingTimeInterval(-3600),
            scanLocation: "VIP Entrance",
            deviceInfo: "iPhone"
          )
        ),
        horses: [
          TicketDirectoryEntry.Horse(
            id: UUID(),
            horseName: "Thunderbolt",
            ownershipLabel: "Sponsored by Doe Family",
            state: .confirmed,
            ownerEmail: "john.doe@example.com",
            ownerName: "John Doe",
            laneNumber: 3,
            roundId: UUID(),
            roundName: "Round 1",
            roundStartAt: Date(),
            roundEndAt: Date().addingTimeInterval(1800)
          )
        ]
      )
    ) {
      ScanResultFeature()
    }
  )
}
