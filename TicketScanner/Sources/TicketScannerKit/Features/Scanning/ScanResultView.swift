import SwiftUI

public struct ScanResultView: View {
  let result: ScanResult
  let onDismiss: () -> Void

  public init(result: ScanResult, onDismiss: @escaping () -> Void) {
    self.result = result
    self.onDismiss = onDismiss
  }

  public var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        // Status Icon
        Image(systemName: result.success ? "checkmark.circle.fill" : "xmark.circle.fill")
          .font(.system(size: 60))
          .foregroundColor(result.success ? .green : .red)

        // Message
        Text(result.message)
          .font(.headline)
          .multilineTextAlignment(.center)
          .padding(.horizontal)

        // Ticket Info
        if let ticket = result.ticket {
          VStack(alignment: .leading, spacing: 8) {
            Text("Ticket Details")
              .font(.headline)

            HStack {
              Text("Name:")
              Spacer()
              Text(ticket.attendeeName)
                .fontWeight(.medium)
            }

            if let seat = ticket.seatAssignment {
              HStack {
                Text("Seat:")
                Spacer()
                Text(seat)
                  .fontWeight(.medium)
              }
            }

            HStack {
              Text("Status:")
              Spacer()
              Text(ticket.state.displayName)
                .fontWeight(.medium)
            }

            if let scannedAt = ticket.scannedAt {
              HStack {
                Text("Scanned:")
                Spacer()
                Text(scannedAt.formatted(date: .abbreviated, time: .shortened))
                  .fontWeight(.medium)
              }
            }
          }
          .padding()
          .background(Color(.systemGray6))
          .cornerRadius(8)
        }

        // Previous Scan Info
        if result.alreadyScanned, let previousScan = result.previousScan {
          VStack(alignment: .leading, spacing: 8) {
            Text("Previously Scanned")
              .font(.headline)
              .foregroundColor(.orange)

            HStack {
              Text("Scanned by:")
              Spacer()
              Text(previousScan.scanner.fullName)
                .fontWeight(.medium)
            }

            HStack {
              Text("Time:")
              Spacer()
              Text(previousScan.scanTimestamp.formatted(date: .abbreviated, time: .shortened))
                .fontWeight(.medium)
            }

            if let location = previousScan.scanLocation {
              HStack {
                Text("Location:")
                Spacer()
                Text(location)
                  .fontWeight(.medium)
              }
            }
          }
          .padding()
          .background(Color.orange.opacity(0.1))
          .cornerRadius(8)
        }

        Spacer()
      }
      .padding()
      .navigationTitle("Scan Result")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            onDismiss()
          }
        }
      }
    }
  }
}

#Preview {
  ScanResultView(
    result: ScanResult(
      success: true,
      message: "Ticket scanned successfully",
      ticket: Ticket(
        id: UUID(),
        attendeeFirst: "John",
        attendeeLast: "Doe",
        seatingPreference: nil,
        seatAssignment: "Table 5, Seat 3",
        state: .confirmed,
        scannedAt: Date(),
        scannedByUserID: UUID(),
        scanLocation: "Main Entrance"
      ),
      alreadyScanned: false,
      previousScan: nil
    ),
    onDismiss: {}
  )
}
