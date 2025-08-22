import Foundation

/// Centralized pricing configuration for the horse racing fundraiser
enum Pricing {
    
    // MARK: - Item Prices (in cents)
    static let horsePriceCents = 3000      // $30.00
    static let ticketPriceCents = 7500     // $75.00
    static let sponsorPriceCents = 10000   // $100.00
    static let giftBasketPriceCents = 5000 // $50.00
    
    /// Calculate total cost for a collection of items
    /// - Parameters:
    ///   - horseCount: Number of horses
    ///   - ticketCount: Number of tickets
    ///   - sponsorCount: Number of sponsor interests
    ///   - giftBasketCount: Number of gift basket interests
    /// - Returns: Total cost in cents
    static func calculateTotalCents(
        horseCount: Int = 0,
        ticketCount: Int = 0,
        sponsorCount: Int = 0,
        giftBasketCount: Int = 0
    ) -> Int {
        let horseCost = horseCount * horsePriceCents
        let ticketCost = ticketCount * ticketPriceCents
        let sponsorCost = sponsorCount * sponsorPriceCents
        let basketCost = giftBasketCount * giftBasketPriceCents
        
        return horseCost + ticketCost + sponsorCost + basketCost
    }
    
    /// Format a price in cents to a currency string
    /// - Parameter cents: Price in cents
    /// - Returns: Formatted currency string (e.g., "$30.00")
    static func formatCurrency(_ cents: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        let dollars = Double(cents) / 100.0
        return formatter.string(from: NSNumber(value: dollars)) ?? "$0.00"
    }
    
    /// Get the formatted price for a specific item type
    /// - Parameter itemType: The type of item
    /// - Returns: Formatted price string
    static func getFormattedPrice(for itemType: ItemType) -> String {
        switch itemType {
        case .horse:
            return formatCurrency(horsePriceCents)
        case .ticket:
            return formatCurrency(ticketPriceCents)
        case .sponsor:
            return formatCurrency(sponsorPriceCents)
        case .giftBasket:
            return formatCurrency(giftBasketPriceCents)
        }
    }
    
    /// Get the price in cents for a specific item type
    /// - Parameter itemType: The type of item
    /// - Returns: Price in cents
    static func getPriceCents(for itemType: ItemType) -> Int {
        switch itemType {
        case .horse:
            return horsePriceCents
        case .ticket:
            return ticketPriceCents
        case .sponsor:
            return sponsorPriceCents
        case .giftBasket:
            return giftBasketPriceCents
        }
    }
}

// MARK: - Item Types
extension Pricing {
    enum ItemType: CaseIterable {
        case horse
        case ticket
        case sponsor
        case giftBasket
        
        var displayName: String {
            switch self {
            case .horse:
                return "Horse Entry"
            case .ticket:
                return "Event Ticket"
            case .sponsor:
                return "Sponsor Interest"
            case .giftBasket:
                return "Gift Basket Interest"
            }
        }
        
        var description: String {
            switch self {
            case .horse:
                return "Own a horse in the race"
            case .ticket:
                return "Attend the event"
            case .sponsor:
                return "Show your company's support"
            case .giftBasket:
                return "Bid on gift baskets"
            }
        }
    }
}
