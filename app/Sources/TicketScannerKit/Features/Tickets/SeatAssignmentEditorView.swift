import ComposableArchitecture
import SwiftUI

public struct SeatAssignmentEditorView: View {
  @Bindable var store: StoreOf<SeatAssignmentEditorFeature>
  @FocusState private var isEditorFocused: Bool

  public init(store: StoreOf<SeatAssignmentEditorFeature>) {
    self.store = store
  }

  public var body: some View {
    Form {
      Section {
        ZStack(alignment: .topLeading) {
          TextEditor(text: $store.seatAssignmentText)
            .focused($isEditorFocused)
            .frame(minHeight: 120)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.sentences)
            .scrollContentBackground(.hidden)
            .disabled(store.isSaving)
            .overlay {
              if store.isSaving {
                RoundedRectangle(cornerRadius: 8)
                  .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
              }
            }

          if store.seatAssignmentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Text("Add table, row, or other assignment details")
              .foregroundColor(.secondary)
              .padding(.top, 8)
              .padding(.horizontal, 5)
          }
        }
      } header: {
        Text("Seat Assignment")
      } footer: {
        Text("Leave blank to clear the current seat assignment")
      }
    }
    .navigationTitle("Seat Assignment")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        if store.isSaving {
          ProgressView()
        } else {
          Button("Save") {
            store.send(.saveButtonTapped)
          }
          .disabled(store.isSaving)
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
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        isEditorFocused = true
      }
    }
  }
}

#Preview {
  NavigationStack {
    SeatAssignmentEditorView(
      store: Store(
        initialState: SeatAssignmentEditorFeature.State(
          ticketID: UUID(),
          initialSeatAssignment: "Table 10"
        )
      ) {
        SeatAssignmentEditorFeature()
      }
    )
  }
}
