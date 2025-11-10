import ComposableArchitecture
import SwiftUI

public struct AllTicketsView: View {
  @Bindable var store: StoreOf<AllTicketsFeature>

  public init(store: StoreOf<AllTicketsFeature>) {
    self.store = store
  }

  public var body: some View {
    List {
      ForEach(store.filteredTickets) { entry in
        ticketRow(for: entry)
      }
    }
    .listStyle(.insetGrouped)
    .navigationTitle("All Tickets")
    .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .always))
    .overlay {
      overlayView()
    }
    .refreshable {
      store.send(.refresh)
    }
    .task {
      await store.send(.onAppear).finish()
    }
  }

  @ViewBuilder
  private func overlayView() -> some View {
    if store.isLoading && store.tickets.isEmpty {
      ProgressView("Loading tickets...")
    } else if let error = store.errorMessage {
      ContentUnavailableView {
        Label("Unable to load tickets", systemImage: "exclamationmark.triangle")
      } description: {
        Text(error)
      } actions: {
        Button("Retry") {
          store.send(.retry)
        }
      }
    } else if store.tickets.isEmpty {
      ContentUnavailableView(
        "No tickets synced yet",
        systemImage: "ticket.fill"
      )
    } else if !store.searchText.isEmpty && store.filteredTickets.isEmpty {
      ContentUnavailableView(
        "No tickets match “\(store.searchText)”",
        systemImage: "magnifyingglass"
      )
    }
  }

  private func ticketRow(for entry: TicketDirectoryEntry) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(entry.attendeeName)
          .font(.headline)
        Spacer()
        Text(entry.ticket.state.displayName)
          .font(.caption)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(
            entry.ticket.isScanned ? Color.brandGreen.opacity(0.2) : Color.orange.opacity(0.2)
          )
          .clipShape(Capsule())
      }

      if let seat = entry.ticket.seatAssignment, !seat.isEmpty {
        Label("Seat \(seat)", systemImage: "chair")
          .font(.subheadline)
          .foregroundColor(.secondary)
      } else if let pref = entry.ticket.seatingPreference, !pref.isEmpty {
        Label(pref, systemImage: "note.text")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }

      HStack(spacing: 8) {
        Label(entry.ownerName, systemImage: "person.crop.circle")
          .font(.caption)
        Label(entry.ownerEmail, systemImage: "envelope")
          .font(.caption)
      }
      .foregroundStyle(.secondary)

      if entry.ticket.isScanned {
        Label(
          entry.ticket.scannedAt?.formatted(date: .abbreviated, time: .shortened) ?? "Scanned",
          systemImage: "checkmark.seal.fill"
        )
        .font(.caption2)
        .foregroundColor(.green)
      } else {
        Label("Not scanned yet", systemImage: "barcode.viewfinder")
          .font(.caption2)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  NavigationStack {
    AllTicketsView(
      store: Store(initialState: AllTicketsFeature.State()) {
        AllTicketsFeature()
      }
    )
  }
}
