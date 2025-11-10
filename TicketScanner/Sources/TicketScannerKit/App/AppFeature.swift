import ComposableArchitecture
import Foundation
import SwiftUI

#if canImport(UIKit)
  import UIKit
#endif

@Reducer
public struct AppFeature {
  @ObservableState
  public struct State: Equatable {
    public var authentication = AuthenticationFeature.State()
    public var scanning = ScanningFeature.State()
    public var stats = StatsFeature.State()
    public var tickets = AllTicketsFeature.State()
    public var isAuthenticated = false

    public init() {}
  }

  public enum Action: Equatable {
    case authentication(AuthenticationFeature.Action)
    case scanning(ScanningFeature.Action)
    case stats(StatsFeature.Action)
    case tickets(AllTicketsFeature.Action)
    case checkAuthentication
    case handleDeepLink(URL)
    case loadStoredToken
  }

  @Dependency(\.tokenStorage) var tokenStorage

  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(state: \.authentication, action: \.authentication) {
      AuthenticationFeature()
    }

    Scope(state: \.scanning, action: \.scanning) {
      ScanningFeature()
    }

    Scope(state: \.stats, action: \.stats) {
      StatsFeature()
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
        return .send(.loadStoredToken)

      case .loadStoredToken:
        return .run { send in
          @Dependency(\.tokenStorage) var tokenStorage
          if let token = await tokenStorage.getToken() {
            await send(.authentication(.validateToken(token)))
          }
        }

      case .handleDeepLink(let url):
        if url.path.contains("auth") {
          let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
          if let token = components?.queryItems?.first(where: { $0.name == "token" })?.value {
            return .send(.authentication(.validateToken(token)))
          }
        }

        #if canImport(UIKit)
          return .run { _ in
            await MainActor.run {
              guard UIApplication.shared.canOpenURL(url) else { return }
              UIApplication.shared.open(url)
            }
          }
        #else
          return .none
        #endif

      case .stats:
        return .none

      default:
        return .none
      }
    }
  }
}

public struct AppView: View {
  @Bindable var store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public var body: some View {
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
  @Bindable var store: StoreOf<AppFeature>

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
        StatsView(store: store.scope(state: \.stats, action: \.stats))
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
