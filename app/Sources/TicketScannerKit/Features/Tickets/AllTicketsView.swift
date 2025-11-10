import ComposableArchitecture
import SwiftUI

public struct AllTicketsView: View {
  @Bindable var store: StoreOf<AllTicketsFeature>

  public init(store: StoreOf<AllTicketsFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      listContent
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              store.send(.showHorseBoard)
            } label: {
              Label("Horse Board", systemImage: "flag.checkered")
            }
          }
        }
    } destination: { store in
      switch store.state {
      case .detail:
        if let store = store.scope(state: \.detail, action: \.detail) {
          TicketDetailView(store: store)
        }
      case .horseBoard:
        if let store = store.scope(state: \.horseBoard, action: \.horseBoard) {
          HorseBoardView(store: store)
        }
      }
    }
  }

  private var listContent: some View {
    List {
      Section {
        Picker("Filter", selection: $store.filter) {
          ForEach(AllTicketsFeature.State.Filter.allCases, id: \.self) { filter in
            Text(filter.title).tag(filter)
          }
        }
        .pickerStyle(.segmented)
      }
      .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
      .listRowBackground(Color.clear)

      ForEach(store.filteredTickets) { entry in
        Button {
          store.send(.rowTapped(entry.id))
        } label: {
          ticketRow(for: entry)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
          if entry.ticket.isScanned {
            Button(role: .destructive) {
              store.send(.unscanTicket(entry.id))
            } label: {
              Label("Unscan", systemImage: "arrow.uturn.backward")
            }
          }
        }
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
    } else if store.filteredTickets.isEmpty {
      ContentUnavailableView {
        Label("No matches", systemImage: "slider.horizontal.3")
      } description: {
        Text("No \(store.filter.title.lowercased()) tickets match your filters.")
      }
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
          .font(.caption2)
          .foregroundColor(.secondary)
      } else if let pref = entry.ticket.seatingPreference, !pref.isEmpty {
        Label(pref, systemImage: "note.text")
          .font(.caption2)
          .foregroundColor(.secondary)
      }

      if entry.ticket.isScanned {
        Label(
          entry.ticket.scannedAt?.formatted(date: .abbreviated, time: .shortened) ?? "Scanned",
          systemImage: "checkmark.seal"
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
