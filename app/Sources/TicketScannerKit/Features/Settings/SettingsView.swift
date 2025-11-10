import ComposableArchitecture
import SwiftUI

public struct SettingsView: View {
  @Bindable var store: StoreOf<SettingsFeature>

  public init(store: StoreOf<SettingsFeature>) {
    self.store = store
  }

  public var body: some View {
    Form {
      Section("Scan Metadata") {
        TextField(
          "Scan location",
          text: Binding(
            get: { store.preferredLocationName },
            set: { store.send(.setPreferredLocationName($0)) }
          )
        )
        .textInputAutocapitalization(.words)
        .disableAutocorrection(true)
      }

      Section("Feedback") {
        Toggle(
          "Haptic feedback",
          isOn: Binding(
            get: { store.hapticsEnabled },
            set: { store.send(.setHapticsEnabled($0)) }
          )
        )

        Toggle(
          "Audio feedback",
          isOn: Binding(
            get: { store.audioFeedbackEnabled },
            set: { store.send(.setAudioFeedbackEnabled($0)) }
          )
        )

        Toggle(
          "Horse greeting clips",
          isOn: Binding(
            get: { store.horseGreetingsEnabled },
            set: { store.send(.setHorseGreetingsEnabled($0)) }
          )
        )
      }

      Section("Account") {
        Button(role: .destructive) {
          store.send(.logoutTapped)
        } label: {
          Text("Log Out")
        }
      }
    }
    .navigationTitle("Settings")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    SettingsView(
      store: Store(initialState: SettingsFeature.State()) {
        SettingsFeature()
      }
    )
  }
}
