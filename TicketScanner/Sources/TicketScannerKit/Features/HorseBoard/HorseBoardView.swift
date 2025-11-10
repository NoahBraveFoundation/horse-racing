import ComposableArchitecture
import Foundation
import SwiftUI

public struct HorseBoardView: View {
  @Bindable var store: StoreOf<HorseBoardFeature>

  public init(store: StoreOf<HorseBoardFeature>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(store.rounds) { round in
          RoundCard(round: round)
        }
      }
      .padding()
    }
    .background(Color(.systemGroupedBackground))
    .navigationTitle("Horse Board")
    .navigationBarTitleDisplayMode(.inline)
    .refreshable {
      await store.send(.refresh).finish()
    }
    .task {
      await store.send(.onAppear).finish()
    }
    .overlay {
      overlayView
    }
    .alert("Error", isPresented: .constant(store.errorMessage != nil)) {
      Button("OK") {
        store.send(.dismissError)
      }
      Button("Retry") {
        store.send(.refresh)
      }
    } message: {
      Text(store.errorMessage ?? "")
    }
  }

  @ViewBuilder
  private var overlayView: some View {
    if store.isLoading && store.rounds.isEmpty {
      ProgressView("Loading horse board…")
    } else if store.rounds.isEmpty {
      ContentUnavailableView {
        Label("No horse data", systemImage: "tray")
      } description: {
        Text("The horse board will appear once the schedule is published.")
      }
    }
  }
}

private struct RoundCard: View {
  let round: HorseBoardRound

  private let columns = [
    GridItem(.adaptive(minimum: 150), spacing: 12, alignment: .top)
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(round.name)
            .font(.headline)
          if let range = formatTimeRange(for: round) {
            Text(range)
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
        Spacer()
        Text("\(round.lanes.count) lanes")
          .font(.caption)
          .foregroundColor(.secondary)
      }

      LazyVGrid(columns: columns, spacing: 12) {
        ForEach(round.lanes) { lane in
          LaneCard(lane: lane)
        }
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    .shadow(color: Color.black.opacity(0.05), radius: 6, y: 3)
  }

  private func formatTimeRange(for round: HorseBoardRound) -> String? {
    guard let start = round.startAt, let end = round.endAt else { return nil }
    let formatter = Formatters.time
    return "\(formatter.string(from: start)) — \(formatter.string(from: end))"
  }
}

private struct LaneCard: View {
  let lane: HorseBoardLane

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Label("Lane \(lane.number)", systemImage: "flag.checkered")
        .font(.caption)
        .foregroundColor(.secondary)

      if let horse = lane.horse {
        Text(horse.horseName)
          .font(.headline)
        Text(horse.ownershipLabel)
          .font(.subheadline)
          .foregroundColor(.secondary)
        if horse.ownershipLabel != horse.ownerFullName {
          Label(horse.ownerFullName, systemImage: "person.fill")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        StateBadge(state: horse.state)
      } else {
        Spacer(minLength: 0)
        Text("Available")
          .font(.headline)
          .foregroundColor(.secondary)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }

  private var backgroundColor: Color {
    if lane.isAvailable {
      return Color(.systemGray5)
    }
    return Color(.systemGray6)
  }
}

private struct StateBadge: View {
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

private enum Formatters {
  static let time: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
  }()
}
