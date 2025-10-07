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
    private static let sponsorInterestTemplateID = "d-084d37a0692f4450906d65aa5989100d"
    
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
            templateID: loginMagicLinkTemplateID,
            mailSettings: .init(
                bypassSpamManagement: .init(enable: true),
                bypassBounceManagement: .init(enable: true)
            )
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

        req.logger.info("Sending horse racing checkout email to \(user.email) with \(templateData)")
        
        let email = SendGridEmail(
            personalizations: [personalization],
            from: EmailAddress(email: fromEmail, name: fromName),
            templateID: horseRacingCheckoutTemplateID,
            mailSettings: .init(
                bypassSpamManagement: .init(enable: true),
                bypassBounceManagement: .init(enable: true)
            )
        )
        
        let client = getSendGridClient(req)
        try await client.send(email: email)
        
        req.logger.info("Horse racing checkout email sent to \(user.email)")
    }
    
    // MARK: - Horse Racing Confirmed Email
    /// Sends a confirmation email for horse racing event with attached PDF tickets and Apple Wallet passes.
    /// 
    /// This email includes:
    /// - PDF tickets for printing
    /// - Individual Apple Wallet passes (.pkpass files) for each ticket
    /// - Order confirmation details
    /// 
    /// If PDF or Wallet pass generation fails, the email will still be sent without those attachments
    /// rather than failing completely.
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
        
        // Create attachments
        var attachments: [EmailAttachment] = []
        
        do {
            // Generate PDF tickets
            req.logger.info("Generating PDF tickets for cart \(cart.orderNumber)")
            let pdfData = try await TicketService.renderTicketsPDF(for: cart, user: user, on: req)
            
            let pdfAttachment = EmailAttachment(
                content: pdfData.base64EncodedString(),
                type: "application/pdf",
                filename: "tickets.pdf",
                disposition: .attachment
            )
            attachments.append(pdfAttachment)
            req.logger.info("PDF tickets generated successfully: \(pdfData.count) bytes")
            
        } catch {
            req.logger.error("Failed to generate PDF tickets: \(error)")
        }
        
        do {
            // Generate Apple Wallet passes for all tickets
            req.logger.info("Generating Apple Wallet passes for cart \(cart.orderNumber)")
            let walletPasses = try await TicketService.generateAppleWalletPasses(for: cart, user: user, on: req)
            
            // Add Apple Wallet passes as attachments
            for (ticketId, passData) in walletPasses {
                let passAttachment = EmailAttachment(
                    content: passData.base64EncodedString(),
                    type: "application/vnd.apple.pkpass",
                    filename: "ticket-\(ticketId.uuidString.prefix(8)).pkpass",
                    disposition: .attachment
                )
                attachments.append(passAttachment)
            }
            req.logger.info("Apple Wallet passes generated successfully: \(walletPasses.count) passes")
            
        } catch {
            req.logger.error("Failed to generate Apple Wallet passes: \(error)")
        }
        
        let personalization = Personalization(
            to: [EmailAddress(email: user.email, name: user.firstName)],
            dynamicTemplateData: templateData
        )
        
        let email = SendGridEmail(
            personalizations: [personalization],
            from: EmailAddress(email: fromEmail, name: fromName),
            attachments: attachments,
            templateID: horseRacingConfirmedTemplateID,
            mailSettings: .init(
                bypassSpamManagement: .init(enable: true),
                bypassBounceManagement: .init(enable: true)
            )
        )
        
        let client = getSendGridClient(req)
        try await client.send(email: email)
        
        let attachmentCount = attachments.count
        let attachmentTypes = attachments.map { $0.type ?? "unknown" }.joined(separator: ", ")
        req.logger.info("Horse racing confirmed email sent to \(user.email) with \(attachmentCount) attachments: \(attachmentTypes)")
    }

    // MARK: - Sponsor Interest Email
    static func sendSponsorInterestConfirmation(
        to user: User,
        interest: SponsorInterest,
        on req: Request
    ) async throws {
        let templateData: [String: String] = [
            "donationDatePretty": DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none),
            "firstName": user.firstName,
            "email": user.email,
            "companyName": interest.companyName,
            "amountFormatted": formatCurrency(interest.amountCents)
        ]

        let personalization = Personalization(
            to: [EmailAddress(email: user.email, name: user.firstName)],
            dynamicTemplateData: templateData
        )

        let email = SendGridEmail(
            personalizations: [personalization],
            from: EmailAddress(email: fromEmail, name: fromName),
            templateID: sponsorInterestTemplateID,
            mailSettings: .init(
                bypassSpamManagement: .init(enable: true),
                bypassBounceManagement: .init(enable: true)
            )
        )

        let client = getSendGridClient(req)
        try await client.send(email: email)

        req.logger.info("Sponsor interest confirmation email sent to \(user.email) for company \(interest.companyName)")
    }
    
    /// Sends a confirmation email with custom attachment configuration.
    /// 
    /// - Parameters:
    ///   - cart: The cart containing the order details
    ///   - user: The user receiving the email
    ///   - includePDF: Whether to include PDF tickets as attachment
    ///   - includeWalletPasses: Whether to include Apple Wallet passes as attachments
    ///   - req: The Vapor request object
    static func sendHorseRacingConfirmed(
        for cart: Cart,
        user: User,
        includePDF: Bool = true,
        includeWalletPasses: Bool = true,
        on req: Request
    ) async throws {
        let templateData = try await buildCheckoutTemplateData(
            cart: cart,
            user: user,
            req: req
        )
        
        // Create attachments
        var attachments: [EmailAttachment] = []
        
        if includePDF {
            do {
                req.logger.info("Generating PDF tickets for cart \(cart.orderNumber)")
                let pdfData = try await TicketService.renderTicketsPDF(for: cart, user: user, on: req)
                
                let pdfAttachment = EmailAttachment(
                    content: pdfData.base64EncodedString(),
                    type: "application/pdf",
                    filename: "tickets.pdf",
                    disposition: .attachment
                )
                attachments.append(pdfAttachment)
                req.logger.info("PDF tickets generated successfully: \(pdfData.count) bytes")
                
            } catch {
                req.logger.error("Failed to generate PDF tickets: \(error)")
            }
        }
        
        if includeWalletPasses {
            do {
                req.logger.info("Generating Apple Wallet passes for cart \(cart.orderNumber)")
                let walletPasses = try await TicketService.generateAppleWalletPasses(for: cart, user: user, on: req)
                
                for (ticketId, passData) in walletPasses {
                    let passAttachment = EmailAttachment(
                        content: passData.base64EncodedString(),
                        type: "application/vnd.apple.pkpass",
                        filename: "ticket-\(ticketId.uuidString.prefix(8)).pkpass",
                        disposition: .attachment
                    )
                    attachments.append(passAttachment)
                }
                req.logger.info("Apple Wallet passes generated successfully: \(walletPasses.count) passes")
                
            } catch {
                req.logger.error("Failed to generate Apple Wallet passes: \(error)")
            }
        }
        
        let personalization = Personalization(
            to: [EmailAddress(email: user.email, name: user.firstName)],
            dynamicTemplateData: templateData
        )

        req.logger.info("Sending horse racing confirmed email to \(user.email) with \(templateData)")
        
        let email = SendGridEmail(
            personalizations: [personalization],
            from: EmailAddress(email: fromEmail, name: fromName),
            attachments: attachments,
            templateID: horseRacingConfirmedTemplateID,
            mailSettings: .init(
                bypassSpamManagement: .init(enable: true),
                bypassBounceManagement: .init(enable: true)
            )
        )
        
        let client = getSendGridClient(req)
        try await client.send(email: email)
        
        let attachmentCount = attachments.count
        let attachmentTypes = attachments.map { $0.type ?? "unknown" }.joined(separator: ", ")
        req.logger.info("Horse racing confirmed email sent to \(user.email) with \(attachmentCount) attachments: \(attachmentTypes)")
    }
    
    // MARK: - Helper Methods
    private static func buildCheckoutTemplateData(
        cart: Cart,
        user: User,
        req: Request
    ) async throws -> CheckoutTemplateData {
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
        
        // Build template data using proper structs
        let templateData = CheckoutTemplateData(
            orderId: orderID,
            firstName: user.firstName,
            purchaseDatePretty: purchaseDatePretty,
            year: "2025",
            totalFormatted: formatCurrency(totalCents),
            venmoUrl: venmoLink,
            horses: horses.map { horse in
                HorseTemplateData(
                    horseName: horse.horseName,
                    ownershipLabel: horse.ownershipLabel,
                    costFormatted: Pricing.getFormattedPrice(for: .horse)
                )
            },
            tickets: tickets.map { ticket in
                TicketTemplateData(
                    attendeeFirst: ticket.attendeeFirst,
                    attendeeLast: ticket.attendeeLast,
                    costFormatted: Pricing.getFormattedPrice(for: .ticket)
                )
            },
            sponsorInterests: sponsorInterests.map { sponsor in
                SponsorTemplateData(
                    companyName: sponsor.companyName,
                    costFormatted: Pricing.formatCurrency(sponsor.amountCents)
                )
            },
            giftBasketInterests: giftBasketInterests.map { basket in
                GiftBasketTemplateData(
                    description: basket.descriptionText
                )
            }
        )
        
        return templateData
    }
    
    private static func calculateTotalCost(
        horses: [Horse],
        tickets: [Ticket],
        sponsorInterests: [SponsorInterest],
        giftBasketInterests: [GiftBasketInterest]
    ) -> Int {
        let sponsorTotal = sponsorInterests.reduce(0) { $0 + $1.amountCents }
        return Pricing.calculateTotalCents(
            horseCount: horses.count,
            ticketCount: tickets.count,
            sponsorCents: sponsorTotal,
            giftBasketCount: giftBasketInterests.count
        )
    }
    
    private static func formatCurrency(_ cents: Int) -> String {
        return Pricing.formatCurrency(cents)
    }
}

// MARK: - Template Data Structures

struct CheckoutTemplateData: Codable, Sendable {
    let orderId: String
    let firstName: String
    let purchaseDatePretty: String
    let year: String
    let totalFormatted: String
    let venmoUrl: String
    let horses: [HorseTemplateData]
    let tickets: [TicketTemplateData]
    let sponsorInterests: [SponsorTemplateData]
    let giftBasketInterests: [GiftBasketTemplateData]
}

struct HorseTemplateData: Codable, Sendable {
    let horseName: String
    let ownershipLabel: String
    let costFormatted: String
}

struct TicketTemplateData: Codable, Sendable {
    let attendeeFirst: String
    let attendeeLast: String
    let costFormatted: String
}

struct SponsorTemplateData: Codable, Sendable {
    let companyName: String
    let costFormatted: String
}

struct GiftBasketTemplateData: Codable, Sendable {
    let description: String
}
