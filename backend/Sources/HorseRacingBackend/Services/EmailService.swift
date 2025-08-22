import Vapor
import SendGridKit
import Foundation

struct EmailService {
    // MARK: - Configuration
    private static let fromEmail = "noreply@noahbrave.org"
    private static let fromName = "NoahBRAVE Foundation"
    
    // MARK: - Template IDs
    private static let loginMagicLinkTemplateID = "d-30146812f5984bde82cfa312a8539fe7"
    private static let horseRacingCheckoutTemplateID = "d-3ae5734302034b1c9c95329a2889316d"
    private static let horseRacingConfirmedTemplateID = "d-9e37ab3d3fdd4b4098fc296bf76fb975"
    
    // MARK: - SendGrid Client
    private static func getSendGridClient(_ req: Request) -> SendGridClient {
        guard let apiKey = Environment.get("SENDGRID_API_KEY") else {
            req.logger.error("SENDGRID_API_KEY environment variable not set")
            fatalError("SENDGRID_API_KEY environment variable not set")
        }
        
        return SendGridClient(httpClient: req.application.http.client.shared, apiKey: apiKey)
    }
    
    // MARK: - Login Magic Link Email
    static func sendLoginMagicLink(
        to user: User,
        magicLinkURL: String,
        expiresInMinutes: Int,
        on req: Request
    ) async throws {
        let templateData: [String: String] = [
            "first_name": user.firstName,
            "magic_link_url": magicLinkURL,
            "expires_in_minutes": String(expiresInMinutes),
            "year": "2025"
        ]
        
        let personalization = Personalization(
            to: [EmailAddress(email: user.email, name: user.firstName)],
            dynamicTemplateData: templateData
        )
        
        let email = SendGridEmail(
            personalizations: [personalization],
            from: EmailAddress(email: fromEmail, name: fromName),
            templateID: loginMagicLinkTemplateID
        )
        
        let client = getSendGridClient(req)
        try await client.send(email: email)
        
        req.logger.info("Login magic link email sent to \(user.email)")
    }
    
    // MARK: - Horse Racing Checkout Email
    static func sendHorseRacingCheckout(
        for cart: Cart,
        user: User,
        on req: Request
    ) async throws {
        let templateData = try await buildCheckoutTemplateData(
            cart: cart,
            user: user,
            req: req
        )
        
        let personalization = Personalization(
            to: [EmailAddress(email: user.email, name: user.firstName)],
            dynamicTemplateData: templateData
        )
        
        let email = SendGridEmail(
            personalizations: [personalization],
            from: EmailAddress(email: fromEmail, name: fromName),
            templateID: horseRacingCheckoutTemplateID
        )
        
        let client = getSendGridClient(req)
        try await client.send(email: email)
        
        req.logger.info("Horse racing checkout email sent to \(user.email)")
    }
    
    // MARK: - Horse Racing Confirmed Email
    static func sendHorseRacingConfirmed(
        for cart: Cart,
        user: User,
        on req: Request
    ) async throws {
        let templateData = try await buildCheckoutTemplateData(
            cart: cart,
            user: user,
            req: req
        )
        
        let personalization = Personalization(
            to: [EmailAddress(email: user.email, name: user.firstName)],
            dynamicTemplateData: templateData
        )
        
        let email = SendGridEmail(
            personalizations: [personalization],
            from: EmailAddress(email: fromEmail, name: fromName),
            templateID: horseRacingConfirmedTemplateID
        )
        
        let client = getSendGridClient(req)
        try await client.send(email: email)
        
        req.logger.info("Horse racing confirmed email sent to \(user.email)")
    }
    
    // MARK: - Helper Methods
    private static func buildCheckoutTemplateData(
        cart: Cart,
        user: User,
        req: Request
    ) async throws -> [String: String] {
        // Get cart items with their relationships
        let horses = try await cart.$horses.get(on: req.db)
        let tickets = try await cart.$tickets.get(on: req.db)
        let sponsorInterests = try await cart.$sponsorInterests.get(on: req.db)
        let giftBasketInterests = try await cart.$giftBasketInterests.get(on: req.db)
        
        // Calculate total cost
        let totalCents = calculateTotalCost(
            horses: horses,
            tickets: tickets,
            sponsorInterests: sponsorInterests,
            giftBasketInterests: giftBasketInterests
        )
        
        // Use the cart's computed order number
        let orderID = cart.orderNumber
        
        // Format purchase date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let purchaseDatePretty = dateFormatter.string(from: cart.createdAt ?? Date())
        
        // Generate Venmo link
        let venmoLink = VenmoLinkService.generatePaymentLink(totalCents: totalCents, orderNumber: orderID)
        
        // Build template data
        var templateData: [String: String] = [
            "order_id": orderID,
            "first_name": user.firstName,
            "purchase_date_pretty": purchaseDatePretty,
            "year": "2025",
            "total_formatted": formatCurrency(totalCents),
            "venmo_url": venmoLink
        ]
        
        // Add horses data as JSON string
        let horsesData = horses.map { horse in
            [
                "horseName": horse.horseName,
                "ownershipLabel": horse.ownershipLabel,
                "cost_formatted": Pricing.getFormattedPrice(for: .horse)
            ]
        }
        if let horsesJSON = try? JSONSerialization.data(withJSONObject: horsesData),
           let horsesString = String(data: horsesJSON, encoding: .utf8) {
            templateData["horses"] = horsesString
        }
        
        // Add tickets data as JSON string
        let ticketsData = tickets.map { ticket in
            [
                "attendeeFirst": ticket.attendeeFirst,
                "attendeeLast": ticket.attendeeLast,
                "cost_formatted": Pricing.getFormattedPrice(for: .ticket)
            ]
        }
        if let ticketsJSON = try? JSONSerialization.data(withJSONObject: ticketsData),
           let ticketsString = String(data: ticketsJSON, encoding: .utf8) {
            templateData["tickets"] = ticketsString
        }
        
        // Add sponsor interests data as JSON string
        let sponsorData = sponsorInterests.map { sponsor in
            [
                "companyName": sponsor.companyName,
                "cost_formatted": Pricing.getFormattedPrice(for: .sponsor)
            ]
        }
        if let sponsorJSON = try? JSONSerialization.data(withJSONObject: sponsorData),
           let sponsorString = String(data: sponsorJSON, encoding: .utf8) {
            templateData["sponsorInterests"] = sponsorString
        }
        
        // Add gift basket interests data as JSON string
        let basketData = giftBasketInterests.map { basket in
            [
                "description": basket.descriptionText
            ]
        }
        if let basketJSON = try? JSONSerialization.data(withJSONObject: basketData),
           let basketString = String(data: basketJSON, encoding: .utf8) {
            templateData["giftBasketInterests"] = basketString
        }
        
        return templateData
    }
    
    private static func calculateTotalCost(
        horses: [Horse],
        tickets: [Ticket],
        sponsorInterests: [SponsorInterest],
        giftBasketInterests: [GiftBasketInterest]
    ) -> Int {
        return Pricing.calculateTotalCents(
            horseCount: horses.count,
            ticketCount: tickets.count,
            sponsorCount: sponsorInterests.count,
            giftBasketCount: giftBasketInterests.count
        )
    }
    
    private static func formatCurrency(_ cents: Int) -> String {
        return Pricing.formatCurrency(cents)
    }
}
