import ComposableArchitecture
import SwiftUI
import TicketScannerKit

@main
struct TicketScannerApp: App {
  @State var store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }

  init() {
    ensureLoggingBootstrapped()
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: store)
    }
  }
}
