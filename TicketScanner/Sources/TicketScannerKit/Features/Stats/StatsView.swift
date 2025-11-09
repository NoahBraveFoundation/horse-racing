import Charts
import ComposableArchitecture
import SwiftUI

public struct StatsView: View {
  let store: StoreOf<ScanningFeature>

  public init(store: StoreOf<ScanningFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          // Overall Stats
          if let stats = store.scanningStats {
            VStack(spacing: 16) {
              Text("Scanning Statistics")
                .font(.title2)
                .fontWeight(.bold)

              HStack(spacing: 20) {
                StatCard(
                  title: "Total Scanned",
                  value: "\(stats.totalScanned)",
                  color: .green
                )

                StatCard(
                  title: "Total Tickets",
                  value: "\(stats.totalTickets)",
                  color: .blue
                )

                StatCard(
                  title: "Completion",
                  value: "\(Int(Double(stats.totalScanned) / Double(stats.totalTickets) * 100))%",
                  color: .orange
                )
              }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
          }

          // Recent Scans
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
          .background(Color(.systemBackground))
          .cornerRadius(12)
        }
        .padding()
      }
      .navigationTitle("Statistics")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            // Dismiss the sheet
          }
        }
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

#Preview {
  StatsView(
    store: Store(initialState: ScanningFeature.State()) {
      ScanningFeature()
    }
  )
}
