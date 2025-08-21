import Vapor
import Graphiti
import Fluent

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

    // Tickets
    func purchaseTicket(request: Request, arguments: PurchaseTicketArguments) throws -> EventLoopFuture<Ticket> {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        let ticket = Ticket(ownerID: user.id!, attendeeFirst: arguments.attendeeFirst, attendeeLast: arguments.attendeeLast)
        return ticket.create(on: request.db).flatMap { _ in
            self.updatePaymentTotal(request: request, userID: user.id!, additionalCents: ticketPriceCents)
        }.map { ticket }
    }

    // Horse purchases
    func purchaseHorse(request: Request, arguments: PurchaseHorseArguments) throws -> EventLoopFuture<Horse> {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        
        // Check if user already has a horse in this round
        return Horse.query(on: request.db)
            .filter(\.$owner.$id == user.id!)
            .filter(\.$round.$id == arguments.roundId)
            .first()
            .flatMap { existingUserHorse in
                guard existingUserHorse == nil else { 
                    return request.eventLoop.makeFailedFuture(Abort(.conflict, reason: "User already has a horse in this round")) 
                }
                
                // Check if lane is already occupied in this round
                return Horse.query(on: request.db)
                    .filter(\.$round.$id == arguments.roundId)
                    .filter(\.$lane.$id == arguments.laneId)
                    .first()
                    .flatMap { existingLaneHorse in
                        guard existingLaneHorse == nil else { 
                            return request.eventLoop.makeFailedFuture(Abort(.conflict, reason: "Lane is already occupied in this round")) 
                        }
                        
                        let horse = Horse(ownerID: user.id!, roundID: arguments.roundId, laneID: arguments.laneId, horseName: arguments.horseName, ownershipLabel: arguments.ownershipLabel, state: .onHold)
                        return horse.create(on: request.db).flatMap { _ in
                            self.updatePaymentTotal(request: request, userID: user.id!, additionalCents: horsePriceCents)
                        }.map { horse }
                    }
            }
    }

    func selectHorseLane(request: Request, arguments: SelectHorseLaneArguments) throws -> EventLoopFuture<Horse> {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        // Ensure lane is not taken in that round
        return Horse.query(on: request.db)
            .filter(\.$round.$id == arguments.roundId)
            .filter(\.$lane.$id == arguments.laneId)
            .first()
            .flatMap { existing in
                if let _ = existing { return request.eventLoop.makeFailedFuture(Abort(.conflict, reason: "Lane already taken")) }
                return Horse.find(arguments.horseId, on: request.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { horse in
                        // Ensure user owns this horse
                        guard horse.$owner.id == user.id! else { return request.eventLoop.makeFailedFuture(Abort(.forbidden, reason: "Not your horse")) }
                        guard horse.$round.id == arguments.roundId else { return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Round mismatch")) }
                        horse.$lane.id = arguments.laneId
                        return horse.save(on: request.db).map { horse }
                    }
            }
    }

    func updateHorseState(request: Request, arguments: UpdateHorseStateArguments) throws -> EventLoopFuture<Horse> {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        return Horse.find(arguments.horseId, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (horse: Horse) -> EventLoopFuture<Horse> in
                // Ensure user owns this horse
                guard horse.$owner.id == user.id! else { return request.eventLoop.makeFailedFuture(Abort(.forbidden, reason: "Not your horse")) }
                horse.state = arguments.state
                return horse.save(on: request.db).map { horse }
            }
    }

    // Sponsor interest
    func registerSponsorInterest(request: Request, arguments: SponsorInterestArguments) throws -> EventLoopFuture<SponsorInterest> {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        let si = SponsorInterest(userID: user.id!, companyName: arguments.companyName)
        return si.create(on: request.db).flatMap { _ in
            self.updatePaymentTotal(request: request, userID: user.id!, additionalCents: sponsorPriceCents)
        }.map { si }
    }

    // Gift basket interest
    func registerGiftBasketInterest(request: Request, arguments: GiftBasketInterestArguments) throws -> EventLoopFuture<GiftBasketInterest> {
        guard let user = request.auth.get(User.self) else { throw Abort(.unauthorized, reason: "User must be authenticated") }
        let gi = GiftBasketInterest(userID: user.id!, descriptionText: arguments.description)
        return gi.create(on: request.db).map { gi }
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

    // Users
    func createUser(request: Request, arguments: CreateUserArguments) throws -> EventLoopFuture<User> {
        let email = arguments.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { throw Abort(.badRequest, reason: "Email required") }
        
        // Check if user already exists
        return User.query(on: request.db)
            .filter(\.$email == email)
            .first()
            .flatMap { existingUser in
                if let _ = existingUser {
                    return request.eventLoop.makeFailedFuture(Abort(.conflict, reason: "User with this email already exists"))
                }
                
                let user = User(email: email, firstName: arguments.firstName, lastName: arguments.lastName)
                return user.create(on: request.db).map { user }
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
}
