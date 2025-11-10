import Foundation
import Dependencies

public struct TokenStorage: Sendable {
    public var saveToken: @Sendable (String) async -> Void
    public var getToken: @Sendable () async -> String?
    public var clearToken: @Sendable () async -> Void
}

extension TokenStorage: DependencyKey {
    public static let liveValue = TokenStorage(
        saveToken: { token in
            UserDefaults.standard.set(token, forKey: "authToken")
        },
        getToken: {
            UserDefaults.standard.string(forKey: "authToken")
        },
        clearToken: {
            UserDefaults.standard.removeObject(forKey: "authToken")
        }
    )
}

extension DependencyValues {
    public var tokenStorage: TokenStorage {
        get { self[TokenStorage.self] }
        set { self[TokenStorage.self] = newValue }
    }
}
