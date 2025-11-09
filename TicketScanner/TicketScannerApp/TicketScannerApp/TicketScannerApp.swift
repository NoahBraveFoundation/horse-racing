import ComposableArchitecture
import SwiftUI
import TicketScannerKit
import UIKit

@main
struct TicketScannerApp: App {
  @State var store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: store)
    }
  }
}

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {
    var authentication = AuthenticationFeature.State()
    var scanning = ScanningFeature.State()
    var isAuthenticated = false
  }

  enum Action: Equatable {
    case authentication(AuthenticationFeature.Action)
    case scanning(ScanningFeature.Action)
    case checkAuthentication
    case handleDeepLink(URL)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.authentication, action: \.authentication) {
      AuthenticationFeature()
    }

    Scope(state: \.scanning, action: \.scanning) {
      ScanningFeature()
    }

    Reduce { state, action in
      switch action {
      case .authentication(.validateTokenResponse(.success(let user))):
        state.isAuthenticated = true
        state.scanning.currentScanner = user
        return .none

      case .authentication(.logout):
        state.isAuthenticated = false
        state.scanning.currentScanner = nil
        return .none

      case .checkAuthentication:
        // In a real app, you'd check for stored authentication
        return .none
        
      case .handleDeepLink(let url):
        // Check if this is an auth callback URL
        if url.host == "auth-callback" || url.path.contains("auth-callback") {
          // Extract the token from the URL
          let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
          if let token = components?.queryItems?.first(where: { $0.name == "token" })?.value {
            return .send(.authentication(.validateToken(token)))
          }
        }
        // For other URLs, open in Safari
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url)
        }
        return .none

      default:
        return .none
      }
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    Group {
      if store.isAuthenticated {
        ScanningView(store: store.scope(state: \.scanning, action: \.scanning))
      } else {
        LoginView(store: store.scope(state: \.authentication, action: \.authentication))
      }
    }
    .onAppear {
      store.send(.checkAuthentication)
    }
    .onOpenURL { url in
      store.send(.handleDeepLink(url))
    }
  }
}
