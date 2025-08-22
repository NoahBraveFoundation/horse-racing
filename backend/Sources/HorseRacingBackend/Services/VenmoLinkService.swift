import Foundation

/// Service for generating Venmo payment links
struct VenmoLinkService {
    
    // MARK: - Configuration
    static let venmoUser = "Gina-Evans-34"
    private static let baseURL = "https://venmo.com"
    
    // MARK: - Public Methods
    
    /// Generate a Venmo payment link for a cart
    /// - Parameters:
    ///   - total: Total amount in dollars (e.g., 300.0 for $300)
    ///   - orderNumber: The order number to include in the note
    /// - Returns: Complete Venmo payment URL
    static func generatePaymentLink(total: Double, orderNumber: String) -> String {
        let encodedTotal = encodeURIComponent(String(format: "%.2f", total))
        let encodedNote = encodeURIComponent(orderNumber)
        
        return "\(baseURL)/\(venmoUser)?txn=pay&amount=\(encodedTotal)&note=\(encodedNote)"
    }
    
    /// Generate a Venmo payment link for a cart with total in cents
    /// - Parameters:
    ///   - totalCents: Total amount in cents
    ///   - orderNumber: The order number to include in the note
    /// - Returns: Complete Venmo payment URL
    static func generatePaymentLink(totalCents: Int, orderNumber: String) -> String {
        let totalDollars = Double(totalCents) / 100.0
        return generatePaymentLink(total: totalDollars, orderNumber: orderNumber)
    }
    
    /// Generate a simple Venmo profile link
    /// - Returns: Venmo profile URL
    static func generateProfileLink() -> String {
        return "\(baseURL)/\(venmoUser)"
    }
    
    // MARK: - Helper Methods
    
    /// Encode a string for use in a URL query parameter
    /// - Parameter string: The string to encode
    /// - Returns: URL-encoded string
    private static func encodeURIComponent(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}
