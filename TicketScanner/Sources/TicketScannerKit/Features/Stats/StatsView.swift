import ComposableArchitecture
import SwiftUI

public struct StatsView: View {
  @Bindable var store: StoreOf<StatsFeature>

  public init(store: StoreOf<StatsFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      ScrollView {
        content
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

  private var content: some View {
    VStack(alignment: .leading, spacing: 20) {
      statsSection
      recentScansSection
    }
    .padding()
  }

  @ViewBuilder
  private var statsSection: some View {
    if let stats = store.scanningStats {
      StatsOverviewSection(stats: stats)
    }
  }

  private var recentScansSection: some View {
    RecentScansSection(scans: store.recentScans) { id in
      store.send(.openTicket(id))
    } onUnscan: { id in
      store.send(.unscanTicket(id))
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

      HStack(spacing: 20) {
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

private struct RecentScansSection: View {
  let scans: [TicketScan]
  let onSelect: (UUID) -> Void
  let onUnscan: (UUID) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Recent Scans")
        .font(.title2)
        .fontWeight(.bold)

      if scans.isEmpty {
        Text("No recent scans")
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
      } else {
        LazyVStack(spacing: 8) {
          ForEach(scans) { scan in
            Button {
              onSelect(scan.ticket.id)
            } label: {
              RecentScanRow(scan: scan)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(role: .destructive) {
                onUnscan(scan.ticket.id)
              } label: {
                Label("Unscan", systemImage: "arrow.uturn.backward")
              }
            }
          }
        }
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
