import ComposableArchitecture
import SwiftUI

public struct StatsView: View {
  @Bindable var store: StoreOf<StatsFeature>

  public init(store: StoreOf<StatsFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        // Stats Section
        if let stats = store.state.scanningStats {
          StatsOverviewSection(stats: stats)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }

        // Recent Scans Section
        Section(header: Text("Recent Scans")) {
          if store.recentScans.isEmpty {
            Text("No recent scans")
              .foregroundColor(.secondary)
          } else {
            ForEach(store.recentScans) { scan in
              Button {
                store.send(.openTicket(scan.ticket.id))
              } label: {
                RecentScanRow(scan: scan)
              }
              .buttonStyle(.plain)
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  store.send(.unscanTicket(scan.ticket.id))
                } label: {
                  Label("Unscan", systemImage: "arrow.uturn.backward")
                }
              }
            }
          }
        }
      }
      .refreshable {
        await store.send(.refresh(.userInitiated)).finish()
      }
      .navigationTitle("Statistics")
      .navigationBarTitleDisplayMode(.inline)
      .alert("Error", isPresented: .constant(store.errorMessage != nil)) {
        Button("OK") {
          store.send(.clearError)
        }
      } message: {
        Text(store.errorMessage ?? "")
      }
      .overlay(alignment: .top) {
        if store.isLoading && store.scanningStats == nil {
          ProgressView()
            .padding()
        }
      }
      .onAppear {
        store.send(.onAppear)
      }
    } destination: { pathStore in
      destinationView(for: pathStore)
    }
  }

  @ViewBuilder
  private func destinationView(
    for store: Store<StatsFeature.Path.State, StatsFeature.Path.Action>
  ) -> some View {
    switch store.state {
    case .detail:
      if let store = store.scope(state: \.detail, action: \.detail) {
        TicketDetailView(store: store)
      }
    }
  }
}

struct StatCard: View {
  let title: String
  let value: String
  let color: Color

  var body: some View {
    VStack(spacing: 4) {
      Text(value)
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(color)

      Text(title)
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(8)
  }
}

struct RecentScanRow: View {
  let scan: TicketScan

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(scan.ticket.attendeeName)
          .font(.headline)

        Text("Scanned by \(scan.scanner.fullName)")
          .font(.caption)
          .foregroundColor(.secondary)

        if let location = scan.scanLocation {
          Text(location)
            .font(.caption2)
            .foregroundColor(.secondary)
        }
      }

      Spacer()

      VStack(alignment: .trailing, spacing: 4) {
        Text(scan.scanTimestamp.formatted(date: .omitted, time: .shortened))
          .font(.caption)
          .fontWeight(.medium)

        Text(scan.scanTimestamp.formatted(date: .abbreviated, time: .omitted))
          .font(.caption2)
          .foregroundColor(.secondary)
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(8)
  }
}

private struct StatsOverviewSection: View {
  let stats: ScanningStats

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Scanning Statistics")
        .font(.title2)
        .fontWeight(.bold)

      HStack(spacing: 8) {
        StatCard(
          title: "Scanned",
          value: "\(stats.totalScanned)",
          color: .green
        )

        StatCard(
          title: "Total",
          value: "\(stats.totalTickets)",
          color: .blue
        )

        let completion =
          stats.totalTickets == 0
          ? 0
          : Int(Double(stats.totalScanned) / Double(stats.totalTickets) * 100)

        StatCard(
          title: "Completed",
          value: "\(completion)%",
          color: .orange
        )
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

#Preview {
  StatsView(
    store: Store(initialState: StatsFeature.State()) {
      StatsFeature()
    }
  )
}
