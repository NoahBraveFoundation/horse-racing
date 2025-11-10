import Charts
import ComposableArchitecture
import SwiftUI

public struct StatsView: View {
  @Bindable var store: StoreOf<StatsFeature>

  public init(store: StoreOf<StatsFeature>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        if let stats = store.scanningStats {
          Text("Scanning Statistics")
            .font(.title2)
            .fontWeight(.bold)
          VStack(spacing: 16) {
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

              StatCard(
                title: "Completed",
                value: "\(Int(Double(stats.totalScanned) / Double(stats.totalTickets) * 100))%",
                color: .orange
              )
            }
          }
          .padding()
          .background(Color(.systemGray6))
          .cornerRadius(12)
        }

        VStack(alignment: .leading, spacing: 12) {
          Text("Recent Scans")
            .font(.title2)
            .fontWeight(.bold)

          let recentScans = store.recentScans

          if recentScans.isEmpty {
            Text("No recent scans")
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding()
          } else {
            LazyVStack(spacing: 8) {
              ForEach(recentScans) { scan in
                RecentScanRow(scan: scan)
              }
            }
          }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
      }
      .padding()
    }
    .refreshable {
      await store.send(.refresh(.userInitiated))
    }
    .navigationTitle("Statistics")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        if store.isLoading {
          ProgressView()
        } else {
          Button {
            store.send(.refresh(.userInitiated))
          } label: {
            Image(systemName: "arrow.clockwise")
          }
          .accessibilityLabel("Refresh statistics")
        }
      }
    }
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

#Preview {
  StatsView(
    store: Store(initialState: StatsFeature.State()) {
      StatsFeature()
    }
  )
}
