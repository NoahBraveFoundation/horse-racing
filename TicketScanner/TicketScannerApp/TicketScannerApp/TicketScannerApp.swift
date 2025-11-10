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
    var tickets = AllTicketsFeature.State()
    var isAuthenticated = false
  }

  enum Action: Equatable {
    case authentication(AuthenticationFeature.Action)
    case scanning(ScanningFeature.Action)
    case tickets(AllTicketsFeature.Action)
    case checkAuthentication
    case handleDeepLink(URL)
    case loadStoredToken
  }

  @Dependency(\.tokenStorage) var tokenStorage

  var body: some ReducerOf<Self> {
    Scope(state: \.authentication, action: \.authentication) {
      AuthenticationFeature()
    }

    Scope(state: \.scanning, action: \.scanning) {
      ScanningFeature()
    }

    Scope(state: \.tickets, action: \.tickets) {
      AllTicketsFeature()
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
        // Check for stored authentication token on app launch
        return .send(.loadStoredToken)

      case .loadStoredToken:
        return .run { send in
          @Dependency(\.tokenStorage) var tokenStorage
          if let token = await tokenStorage.getToken() {
            // Validate the stored token
            await send(.authentication(.validateToken(token)))
          }
        }

      case .handleDeepLink(let url):
        // Check if this is an auth callback URL
        if url.path.contains("auth") {
          // Extract the token from the URL
          let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
          if let token = components?.queryItems?.first(where: { $0.name == "token" })?.value {
            return .send(.authentication(.validateToken(token)))
          }
        }
        // For other URLs, open in Safari on the main actor
        return .run { _ in
          await MainActor.run {
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
          }
        }

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
        AuthenticatedView(store: store)
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

struct AuthenticatedView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    TabView {
      NavigationStack {
        ScanningView(
          store: store.scope(state: \.scanning, action: \.scanning),
          onLogout: { store.send(.authentication(.logout)) }
        )
      }
      .tabItem {
        Label("Scan", systemImage: "barcode.viewfinder")
      }

      NavigationStack {
        StatsView(store: store.scope(state: \.scanning, action: \.scanning))
      }
      .tabItem {
        Label("Stats", systemImage: "chart.bar.doc.horizontal")
      }

      NavigationStack {
        AllTicketsView(store: store.scope(state: \.tickets, action: \.tickets))
      }
      .tabItem {
        Label("Tickets", systemImage: "list.bullet")
      }
    }
  }
}
