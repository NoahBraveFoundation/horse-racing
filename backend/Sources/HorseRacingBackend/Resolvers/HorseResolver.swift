import Vapor
import Graphiti
import Fluent
import Security

private let ticketPriceCents = 7500
private let horsePriceCents = 3000
private let sponsorPriceCents = 10000

final class HorseResolver: @unchecked Sendable {
    // Rounds
    func getRounds(request: Request, _: NoArguments) throws -> EventLoopFuture<[Round]> {
        Round.query(on: request.db).all()
    }

    func getLanes(request: Request, arguments: GetLanesArguments) throws -> EventLoopFuture<[Lane]> {
        Lane.query(on: request.db).filter(\.$round.$id == arguments.roundId).all()
    }

    // Current user
    func me(request: Request, _: NoArguments) throws -> User {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        return user
    }

    // Payment tracking
    func getPaymentStatus(request: Request, _: NoArguments) throws -> EventLoopFuture<Payment?> {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        return Payment.query(on: request.db).filter(\.$user.$id == user.id!).first()
    }

    func markPaymentReceived(request: Request, arguments: MarkPaymentReceivedArguments) throws -> EventLoopFuture<Payment> {
        // Admin-only
        guard let currentUser = request.auth.get(User.self), currentUser.isAdmin else { throw Abort(.forbidden, reason: "Admin only") }
        return Payment.find(arguments.paymentId, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { payment in
                payment.paymentReceived = true
                payment.paymentReceivedAt = Date()
                return payment.save(on: request.db).map { payment }
            }
    }

    // MARK: - Authentication helpers
    // Helper to set authenticated user in session
    private func setAuthenticatedUser(_ req: Request, user: User) {
        AuthService.setAuthenticatedUser(req, user: user)
    }

    // MARK: - Cart helpers
    private func getOrCreateOpenCart(for userId: UUID, on req: Request) -> EventLoopFuture<Cart> {
        Cart.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$status == .open)
            .first()
            .flatMap { existing -> EventLoopFuture<Cart> in
                if let existing = existing { return req.eventLoop.makeSucceededFuture(existing) }
                
                // Create new cart and automatically add a ticket for the user
                let cart = Cart(userID: userId, status: .open)
                return cart.create(on: req.db).flatMap { _ in
                    // Get user info to create the ticket
                    User.find(userId, on: req.db)
                        .unwrap(or: Abort(.notFound))
                        .flatMap { user in
                            let ticket = Ticket(ownerID: userId, attendeeFirst: user.firstName, attendeeLast: user.lastName, state: .onHold, canRemove: false)
                            ticket.$cart.id = cart.id
                            return ticket.create(on: req.db).map { _ in cart }
                        }
                }
            }
    }

    // MARK: - Cart queries
    // myCart: READ-ONLY query that returns existing cart (if any) regardless of status
    func myCart(request: Request, _: NoArguments) throws -> EventLoopFuture<Cart?> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return Cart.query(on: request.db)
            .filter(\.$user.$id == userId)
            .first()
    }

    // MARK: - Cart mutations
    // getOrCreateCart: MUTATION that creates a new cart if none exists, or returns existing open cart
    func getOrCreateCart(request: Request, _: NoArguments) throws -> EventLoopFuture<Cart> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request)
    }

    func addTicketToCart(request: Request, arguments: AddTicketToCartArguments) throws -> EventLoopFuture<Ticket> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            let ticket = Ticket(ownerID: userId, attendeeFirst: arguments.attendeeFirst, attendeeLast: arguments.attendeeLast, state: .onHold, canRemove: true)
            ticket.$cart.id = cart.id
            return ticket.create(on: request.db).map { ticket }
        }
    }

    func addHorseToCart(request: Request, arguments: AddHorseToCartArguments) throws -> EventLoopFuture<Horse> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        // Ensure one horse per user per round
        return Horse.query(on: request.db)
            .filter(\.$owner.$id == userId)
            .filter(\.$round.$id == arguments.roundId)
            .count()
            .flatMap { userCount in
                guard userCount == 0 else {
                    return request.eventLoop.makeFailedFuture(Abort(.conflict, reason: "User already has a horse in this round")) as EventLoopFuture<Horse>
                }
                // Ensure lane is not taken in that round
                return Horse.query(on: request.db)
                    .filter(\.$round.$id == arguments.roundId)
                    .filter(\.$lane.$id == arguments.laneId)
                    .count()
                    .flatMap { laneCount in
                        guard laneCount == 0 else {
                            return request.eventLoop.makeFailedFuture(Abort(.conflict, reason: "Lane is already occupied in this round")) as EventLoopFuture<Horse>
                        }
                        return self.getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
                            let horse = Horse(ownerID: userId, roundID: arguments.roundId, laneID: arguments.laneId, horseName: arguments.horseName, ownershipLabel: arguments.ownershipLabel, state: .onHold)
                            horse.$cart.id = cart.id
                            return horse.create(on: request.db).map { horse }
                        }
                    }
            }
    }

    func addSponsorToCart(request: Request, arguments: AddSponsorToCartArguments) throws -> EventLoopFuture<SponsorInterest> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            let si = SponsorInterest(userID: userId, companyName: arguments.companyName, companyLogoBase64: arguments.companyLogoBase64)
            si.$cart.id = cart.id
            return si.create(on: request.db).map { si }
        }
    }

    func addGiftBasketToCart(request: Request, arguments: AddGiftBasketToCartArguments) throws -> EventLoopFuture<GiftBasketInterest> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            let gi = GiftBasketInterest(userID: userId, descriptionText: arguments.description)
            gi.$cart.id = cart.id
            return gi.create(on: request.db).map { gi }
        }
    }

    func removeTicketFromCart(request: Request, arguments: RemoveTicketFromCartArguments) throws -> EventLoopFuture<Bool> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            Ticket.query(on: request.db)
                .filter(\.$id == arguments.ticketId)
                .filter(\.$cart.$id == cart.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap { t in t.delete(on: request.db).map { true } }
        }
    }

    func removeHorseFromCart(request: Request, arguments: RemoveHorseFromCartArguments) throws -> EventLoopFuture<Bool> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            Horse.query(on: request.db)
                .filter(\.$id == arguments.horseId)
                .filter(\.$cart.$id == cart.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap { h in h.delete(on: request.db).map { true } }
        }
    }

    func removeSponsorFromCart(request: Request, arguments: RemoveSponsorFromCartArguments) throws -> EventLoopFuture<Bool> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            SponsorInterest.query(on: request.db)
                .filter(\.$id == arguments.sponsorId)
                .filter(\.$cart.$id == cart.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap { s in s.delete(on: request.db).map { true } }
        }
    }

    func removeGiftBasketFromCart(request: Request, arguments: RemoveGiftBasketFromCartArguments) throws -> EventLoopFuture<Bool> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            GiftBasketInterest.query(on: request.db)
                .filter(\.$id == arguments.giftId)
                .filter(\.$cart.$id == cart.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap { g in g.delete(on: request.db).map { true } }
        }
    }

    func checkoutCart(request: Request, _: NoArguments) throws -> EventLoopFuture<Payment> {
        guard let user = request.auth.get(User.self), let userId = user.id else { throw Abort(.unauthorized) }
        return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
            // Load counts
            let ticketsFut = Ticket.query(on: request.db).filter(\.$cart.$id == cart.id!).count()
            let horsesFut = Horse.query(on: request.db).filter(\.$cart.$id == cart.id!).count()
            let sponsorsFut = SponsorInterest.query(on: request.db).filter(\.$cart.$id == cart.id!).count()

            return ticketsFut.and(horsesFut).and(sponsorsFut).flatMap { th, sponsorsCount in
                let (ticketsCount, horsesCount) = th
                let total = ticketsCount * ticketPriceCents + horsesCount * horsePriceCents + sponsorsCount * sponsorPriceCents

                // Transition states for tickets and horses
                let updateTickets = Ticket.query(on: request.db)
                    .filter(\.$cart.$id == cart.id!)
                    .all()
                    .flatMap { tickets in
                        EventLoopFuture.whenAllSucceed(
                            tickets.map { t in
                                t.state = .pendingPayment
                                return t.save(on: request.db)
                            }, on: request.eventLoop
                        )
                    }

                let updateHorses = Horse.query(on: request.db)
                    .filter(\.$cart.$id == cart.id!)
                    .all()
                    .flatMap { horses in
                        EventLoopFuture.whenAllSucceed(
                            horses.map { h in
                                h.state = .pendingPayment
                                return h.save(on: request.db)
                            }, on: request.eventLoop
                        )
                    }

                let updatePayment = Payment.query(on: request.db)
                    .filter(\.$user.$id == userId)
                    .first()
                    .flatMap { existing in
                        if let p = existing {
                            p.totalCents += total
                            return p.save(on: request.db).map { p }
                        } else {
                            let p = Payment(userID: userId, totalCents: total)
                            return p.create(on: request.db).map { p }
                        }
                    }

                let closeCart = { () -> EventLoopFuture<Void> in
                    cart.status = .checkedOut
                    return cart.save(on: request.db)
                }

                return updateTickets.flatMap { _ in
                    updateHorses.flatMap { _ in
                        updatePayment.flatMap { payment in
                            closeCart().map { payment }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Field resolvers
    static func cartCost(cart: Cart) -> (Request, NoArguments, EventLoopGroup) throws -> EventLoopFuture<CartCost> {
        return { req, _, _ in
            let ticketsFut = Ticket.query(on: req.db).filter(\.$cart.$id == cart.id!).count()
            let horsesFut = Horse.query(on: req.db).filter(\.$cart.$id == cart.id!).count()
            let sponsorsFut = SponsorInterest.query(on: req.db).filter(\.$cart.$id == cart.id!).count()
            return ticketsFut.and(horsesFut).and(sponsorsFut).map { th, sponsorsCount in
                let (ticketsCount, horsesCount) = th
                let ticketsCents = ticketsCount * ticketPriceCents
                let horseCents = horsesCount * horsePriceCents
                let sponsorCents = sponsorsCount * sponsorPriceCents
                let totalCents = ticketsCents + horseCents + sponsorCents
                
                return CartCost(
                    ticketsCents: ticketsCents,
                    horseCents: horseCents,
                    sponsorCents: sponsorCents,
                    totalCents: totalCents
                )
            }
        }
    }
    // Users
    func createUser(request: Request, arguments: CreateUserArguments) throws -> EventLoopFuture<User> {
        let email = arguments.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { throw Abort(.badRequest, reason: "Email required") }
        
        // Check if user already exists
        return User.query(on: request.db)
            .filter(\.$email == email)
            .first()
            .flatMap { existingUser -> EventLoopFuture<User> in
                if let _ = existingUser {
                    return request.eventLoop.makeFailedFuture(Abort(.conflict, reason: "User with this email already exists"))
                }
                
                let user = User(email: email, firstName: arguments.firstName, lastName: arguments.lastName)
                return user.create(on: request.db).map { _ in
                    // Set session for immediate authentication
                    self.setAuthenticatedUser(request, user: user)
                    return user
                }
            }
    }

    // Helper method to update payment total
    private func updatePaymentTotal(request: Request, userID: UUID, additionalCents: Int) -> EventLoopFuture<Void> {
        return Payment.query(on: request.db).filter(\.$user.$id == userID).first()
            .flatMap { existingPayment in
                if let payment = existingPayment {
                    payment.totalCents += additionalCents
                    return payment.save(on: request.db).map { _ in }
                } else {
                    let newPayment = Payment(userID: userID, totalCents: additionalCents)
                    return newPayment.create(on: request.db).map { _ in }
                }
            }
    }
    
    // Individual item cost resolvers
    static func ticketCost(ticket: Ticket) -> (Request, NoArguments, EventLoopGroup) throws -> EventLoopFuture<Int> {
        return { req, _, _ in
            return req.eventLoop.makeSucceededFuture(ticketPriceCents)
        }
    }
    
    static func horseCost(horse: Horse) -> (Request, NoArguments, EventLoopGroup) throws -> EventLoopFuture<Int> {
        return { req, _, _ in
            return req.eventLoop.makeSucceededFuture(horsePriceCents)
        }
    }
    
    static func sponsorCost(sponsor: SponsorInterest) -> (Request, NoArguments, EventLoopGroup) throws -> EventLoopFuture<Int> {
        return { req, _, _ in
            return req.eventLoop.makeSucceededFuture(sponsorPriceCents)
        }
    }
    
    static func giftBasketCost(giftBasket: GiftBasketInterest) -> (Request, NoArguments, EventLoopGroup) throws -> EventLoopFuture<Int> {
        return { req, _, _ in
            return req.eventLoop.makeSucceededFuture(0)
        }
    }
}

extension HorseResolver {
    struct GetLanesArguments: Codable { let roundId: UUID }

    struct PurchaseTicketArguments: Codable {
        let attendeeFirst: String
        let attendeeLast: String
    }

    struct PurchaseHorseArguments: Codable {
        let roundId: UUID
        let laneId: UUID
        let horseName: String
        let ownershipLabel: String
    }

    struct SelectHorseLaneArguments: Codable {
        let horseId: UUID
        let roundId: UUID
        let laneId: UUID
    }

    struct UpdateHorseStateArguments: Codable {
        let horseId: UUID
        let state: HorseEntryState
    }

    struct SponsorInterestArguments: Codable {
        let companyName: String
    }

    struct GiftBasketInterestArguments: Codable {
        let description: String
    }

    struct MarkPaymentReceivedArguments: Codable {
        let paymentId: UUID
    }

    struct CreateUserArguments: Codable {
        let email: String
        let firstName: String
        let lastName: String
    }



    // Cart argument types
    struct AddTicketToCartArguments: Codable {
        let attendeeFirst: String
        let attendeeLast: String
    }

    struct AddHorseToCartArguments: Codable {
        let roundId: UUID
        let laneId: UUID
        let horseName: String
        let ownershipLabel: String
    }

    struct AddSponsorToCartArguments: Codable {
        let companyName: String
        let companyLogoBase64: String?
    }

    struct AddGiftBasketToCartArguments: Codable {
        let description: String
    }

    struct RemoveTicketFromCartArguments: Codable { let ticketId: UUID }
    struct RemoveHorseFromCartArguments: Codable { let horseId: UUID }
    struct RemoveSponsorFromCartArguments: Codable { let sponsorId: UUID }
    struct RemoveGiftBasketFromCartArguments: Codable { let giftId: UUID }
    
    struct CartCost: Codable {
        let ticketsCents: Int
        let horseCents: Int
        let sponsorCents: Int
        let totalCents: Int
    }
}
