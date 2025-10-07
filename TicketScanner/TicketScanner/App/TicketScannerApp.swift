import SwiftUI
import ComposableArchitecture

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
            case .authentication(.loginResponse(.success(let user))):
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
                
            default:
                return .none
            }
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        if store.isAuthenticated {
            ScanningView(store: store.scope(state: \.scanning, action: \.scanning))
        } else {
            LoginView(store: store.scope(state: \.authentication, action: \.authentication))
        }
        .onAppear {
            store.send(.checkAuthentication)
        }
    }
}
