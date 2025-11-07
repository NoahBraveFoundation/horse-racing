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
        // Build URL components to ensure query items are properly percent-encoded.
        var components = URLComponents(string: "\(baseURL)/\(venmoUser)")
        components?.queryItems = [
            URLQueryItem(name: "txn", value: "pay"),
            URLQueryItem(name: "amount", value: String(format: "%.2f", total)),
            URLQueryItem(name: "note", value: "A Night at the Races - Order #\(orderNumber)")
        ]

        if let encodedQuery = components?.percentEncodedQuery {
            // Venmo treats literal plus signs in the note as characters rather than spaces,
            // so ensure spaces are encoded with %20 instead.
            components?.percentEncodedQuery = encodedQuery.replacingOccurrences(of: "+", with: "%20")
        }

        // Fallback to basic string construction if URL building fails for any reason.
        return components?.url?.absoluteString ?? "\(baseURL)/\(venmoUser)"
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
}
