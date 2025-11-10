import Crypto  // from swift-crypto
import Vapor

enum AuthService {
  // MARK: - Session Management
  static func setAuthenticatedUser(_ req: Request, user: User) {
    if let id = user.id?.uuidString {
      req.session.data["userID"] = id
      req.auth.login(user)
    }
  }

  // MARK: - Token Generation (CSPRNG via Swift Crypto)
  static func generateSecureLoginToken(for userId: UUID, expiresInMinutes: Int = 30) -> LoginToken {
    // 32 random bytes (256 bits), using CryptoKit-compatible API
    let key = SymmetricKey(size: .bits256)
    let tokenData = key.withUnsafeBytes { Data($0) }

    // URL-safe Base64 (no padding) to make it copy/paste & link friendly
    let tokenString = base64URLEncoded(tokenData)

    let expirationDate = Date().addingTimeInterval(TimeInterval(expiresInMinutes * 60))
    return LoginToken(token: tokenString, userID: userId, expiresAt: expirationDate)
  }

  // MARK: - Helpers
  private static func base64URLEncoded(_ data: Data) -> String {
    let s = data.base64EncodedString()
    return
      s
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
  }
}
