import Vapor
import Security

enum AuthService {
    // MARK: - Session Management
    static func setAuthenticatedUser(_ req: Request, user: User) {
        if let id = user.id?.uuidString {
            req.session.data["userID"] = id
            req.auth.login(user)
        }
    }
    
    // MARK: - Token Generation
    static func generateSecureLoginToken(for userId: UUID) -> LoginToken {
        // Generate cryptographically secure random token using Security framework (32 bytes = 256 bits)
        let tokenData = Data(SecureRandomBytes(count: 32))
        let tokenString = tokenData.base64EncodedString()
        
        // Set consistent expiration (30 minutes from now)
        let expirationDate = Date().addingTimeInterval(30 * 60)
        
        return LoginToken(token: tokenString, userID: userId, expiresAt: expirationDate)
    }
    
    // MARK: - Helper Methods
    private static func SecureRandomBytes(count: Int) -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: count)
        _ = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
        return bytes
    }
}
