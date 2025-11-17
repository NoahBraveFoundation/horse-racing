import Fluent
import Graphiti
import Vapor

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
    guard let user = request.auth.get(User.self) else {
      throw Abort(.unauthorized, reason: "User must be authenticated")
    }
    return user
  }

  // Payment tracking
  func getPaymentStatus(request: Request, _: NoArguments) throws -> EventLoopFuture<Payment?> {
    guard let user = request.auth.get(User.self) else {
      throw Abort(.unauthorized, reason: "User must be authenticated")
    }
    return Payment.query(on: request.db)
      .filter(\.$user.$id == user.id!)
      .sort(\.$createdAt, .descending)
      .with(\.$cart)
      .first()
  }

  func setPaymentReceived(request: Request, arguments: SetPaymentReceivedArguments) throws
    -> EventLoopFuture<Payment>
  {
    // Admin-only
    guard let currentUser = request.auth.get(User.self), currentUser.isAdmin else {
      throw Abort(.forbidden, reason: "Admin only")
    }
    return Payment.find(arguments.paymentId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { payment in
        payment.paymentReceived = arguments.received
        payment.paymentReceivedAt = arguments.received ? Date() : nil

        let userId = payment.$user.id

        return payment.$cart.get(on: request.db).flatMap { linkedCart in
          let cartId = linkedCart?.id

          func ticketQuery(for state: TicketState) -> EventLoopFuture<Void> {
            let builder = Ticket.query(on: request.db)
            if let cartId = cartId {
              builder.filter(\.$cart.$id == cartId)
            } else {
              builder.filter(\.$owner.$id == userId)
            }
            builder.filter(\.$state == state)
            return builder.all().flatMap { tickets in
              EventLoopFuture.whenAllSucceed(
                tickets.map { ticket in
                  ticket.state = arguments.received ? .confirmed : .pendingPayment
                  return ticket.save(on: request.db)
                },
                on: request.eventLoop
              )
              .transform(to: ())
            }
          }

          func horseQuery(for state: HorseEntryState) -> EventLoopFuture<Void> {
            let builder = Horse.query(on: request.db)
            if let cartId = cartId {
              builder.filter(\.$cart.$id == cartId)
            } else {
              builder.filter(\.$owner.$id == userId)
            }
            builder.filter(\.$state == state)
            return builder.all().flatMap { horses in
              EventLoopFuture.whenAllSucceed(
                horses.map { horse in
                  horse.state = arguments.received ? .confirmed : .pendingPayment
                  return horse.save(on: request.db)
                },
                on: request.eventLoop
              )
              .transform(to: ())
            }
          }

          if arguments.received {
            let confirmTickets = ticketQuery(for: .pendingPayment)
            let confirmHorses = horseQuery(for: .pendingPayment)

            let cartForEmail: EventLoopFuture<Cart?>
            if let linkedCart = linkedCart {
              cartForEmail = request.eventLoop.makeSucceededFuture(linkedCart)
            } else {
              cartForEmail = Cart.query(on: request.db)
                .filter(\.$user.$id == userId)
                .filter(\.$status == .checkedOut)
                .sort(\.$updatedAt, .descending)
                .first()
            }

            return
              confirmTickets
              .and(confirmHorses)
              .flatMap { _ in
                payment.save(on: request.db).flatMap { _ in
                  cartForEmail.flatMap { cart in
                    guard let cart = cart else {
                      return request.eventLoop.makeSucceededFuture(payment)
                    }
                    return User.find(userId, on: request.db)
                      .unwrap(or: Abort(.notFound))
                      .map { user in
                        Task {
                          try? await EmailService.sendHorseRacingConfirmed(
                            for: cart, user: user, on: request)
                        }
                        return payment
                      }
                  }
                }
              }
          } else {
            let revertTickets = ticketQuery(for: .confirmed)
            let revertHorses = horseQuery(for: .confirmed)

            return
              revertTickets
              .and(revertHorses)
              .flatMap { _ in payment.save(on: request.db).map { payment } }
          }
        }
      }
  }

  // MARK: - Admin queries and mutations

  func allUsers(request: Request, _: NoArguments) throws -> EventLoopFuture<[User]> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return User.query(on: request.db).all()
  }

  func userById(request: Request, arguments: UserIdArguments) throws -> EventLoopFuture<User> {
    guard let currentUser = request.auth.get(User.self), currentUser.isAdmin else {
      throw Abort(.forbidden)
    }
    return User.find(arguments.userId, on: request.db).unwrap(or: Abort(.notFound))
  }

  func setUserAdmin(request: Request, arguments: SetUserAdminArguments) throws -> EventLoopFuture<
    User
  > {
    guard let currentUser = request.auth.get(User.self), currentUser.isAdmin else {
      throw Abort(.forbidden)
    }
    return User.find(arguments.userId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { user in
        user.isAdmin = arguments.isAdmin
        return user.save(on: request.db).map { user }
      }
  }

  func payments(request: Request, _: NoArguments) throws -> EventLoopFuture<[Payment]> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return Payment.query(on: request.db)
      .with(\.$user)
      .with(\.$cart)
      .sort(\.$paymentReceived, .ascending)
      .sort(\.$createdAt, .descending)
      .all()
  }

  func allHorses(request: Request, _: NoArguments) throws -> EventLoopFuture<[Horse]> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return Horse.query(on: request.db)
      .with(\.$owner)
      .with(\.$round)
      .with(\.$lane)
      .all()
      .map { horses in
        // Sort horses by round start time and lane number
        return horses.sorted { horse1, horse2 in
          // First sort by round start time
          if horse1.round.startAt != horse2.round.startAt {
            return horse1.round.startAt < horse2.round.startAt
          }
          // Then by lane number within the same round
          return horse1.lane.number < horse2.lane.number
        }
      }
  }

  func allTickets(request: Request, _: NoArguments) throws -> EventLoopFuture<[Ticket]> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return Ticket.query(on: request.db)
      .with(\.$owner)
      .with(\.$cart) { builder in
        builder.with(\.$tickets)
      }
      .all()
  }

  func abandonedCarts(request: Request, _: NoArguments) throws -> EventLoopFuture<[Cart]> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return Cart.query(on: request.db).filter(\.$status == .abandoned).with(\.$user).all()
  }

  func releaseHorse(request: Request, arguments: ReleaseHorseArguments) throws -> EventLoopFuture<
    Bool
  > {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return Horse.find(arguments.horseId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { horse in
        horse.delete(on: request.db).map { true }
      }
  }

  func releaseCart(request: Request, arguments: ReleaseCartArguments) throws -> EventLoopFuture<
    Cart
  > {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return Cart.find(arguments.cartId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { cart in
        cart.status = .abandoned
        return cart.save(on: request.db).map { cart }
      }
  }

  func runAdminCleanup(request: Request, _: NoArguments) throws -> EventLoopFuture<Bool> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return CleanupService.runAllCleanups(on: request).map {
      request.logger.info("Manual cleanup completed by admin user: \(user.email)")
      return true
    }
  }

  func resetDatabase(request: Request, _: NoArguments) throws -> EventLoopFuture<Bool> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }

    guard user.email == "austinjevans@me.com" else { throw Abort(.forbidden) }

    request.logger.warning("🚨 DATABASE RESET INITIATED by admin user: \(user.email)")

    // Delete all data in reverse dependency order to avoid foreign key constraints
    // Preserve the admin user (austinjevans@me.com) during reset
    return Payment.query(on: request.db).delete()
      .flatMap { _ in GiftBasketInterest.query(on: request.db).delete() }
      .flatMap { _ in SponsorInterest.query(on: request.db).delete() }
      .flatMap { _ in Ticket.query(on: request.db).delete() }
      .flatMap { _ in Horse.query(on: request.db).delete() }
      .flatMap { _ in Cart.query(on: request.db).delete() }
      .flatMap { _ in LoginToken.query(on: request.db).delete() }
      .flatMap { _ in User.query(on: request.db).filter(\.$email != "austinjevans@me.com").delete()
      }
      .map { _ in
        request.logger.warning(
          "🚨 DATABASE RESET COMPLETED by admin user: \(user.email) - Preserved admin user")
        return true
      }
  }

  func adminStats(request: Request, _: NoArguments) throws -> EventLoopFuture<AdminStats> {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    let ticketCount = Ticket.query(on: request.db).filter(\.$state != .onHold).count()
    let sponsorCount = SponsorInterest.query(on: request.db).count()
    let giftCount = GiftBasketInterest.query(on: request.db).count()
    return ticketCount.and(sponsorCount).and(giftCount).map { ts, gift in
      let (t, s) = ts
      return AdminStats(ticketCount: t, sponsorCount: s, giftBasketCount: gift)
    }
  }

  func allSponsorInterests(request: Request, _: NoArguments) throws -> EventLoopFuture<
    [SponsorInterest]
  > {
    // Public access - sponsors are displayed on the public schedule page
    return SponsorInterest.query(on: request.db).all()
  }

  func adminRemoveSponsorInterest(request: Request, arguments: AdminRemoveSponsorInterestArguments)
    throws -> EventLoopFuture<Bool>
  {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }

    return SponsorInterest.find(arguments.sponsorInterestId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { interest in
        interest.delete(on: request.db).map { true }
      }
  }

  func adminUpdateSponsorLogo(request: Request, arguments: AdminUpdateSponsorLogoArguments)
    throws -> EventLoopFuture<SponsorInterest>
  {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }

    return SponsorInterest.find(arguments.sponsorInterestId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { interest in
        let sanitizedLogo = arguments.companyLogoBase64?.trimmingCharacters(in: .whitespacesAndNewlines)
        interest.companyLogoBase64 = sanitizedLogo?.isEmpty == false ? sanitizedLogo : nil
        return interest.save(on: request.db).map { interest }
      }
  }

  func submitSponsorInterest(request: Request, arguments: SubmitSponsorInterestArguments) throws
    -> EventLoopFuture<SponsorInterest>
  {
    let trimmedEmail = arguments.email.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedName = arguments.name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedCompany = arguments.companyName.trimmingCharacters(in: .whitespacesAndNewlines)
    let sanitizedAmountUsd = arguments.amountUsd.isFinite ? arguments.amountUsd : 0
    let amountCents = Int((sanitizedAmountUsd * 100).rounded())
    let sanitizedLogo = arguments.companyLogoBase64?.trimmingCharacters(in: .whitespacesAndNewlines)

    return User.query(on: request.db)
      .filter(\.$email == trimmedEmail)
      .first()
      .flatMap { existing -> EventLoopFuture<User> in
        if let existing = existing {
          return request.eventLoop.makeSucceededFuture(existing)
        }

        let nameComponents = trimmedName.split(
          separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        let firstName = nameComponents.first.map(String.init) ?? trimmedName
        let lastName = nameComponents.count > 1 ? String(nameComponents.last!) : ""

        let newUser = User(email: trimmedEmail, firstName: firstName, lastName: lastName)
        return newUser.create(on: request.db).map { newUser }
      }
      .flatMap { (user: User) -> EventLoopFuture<SponsorInterest> in
        do {
          let userID = try user.requireID()
          let sponsorInterest = SponsorInterest(
            userID: userID,
            companyName: trimmedCompany,
            amountCents: max(0, amountCents),
            companyLogoBase64: sanitizedLogo?.isEmpty == false ? sanitizedLogo : nil
          )
          return sponsorInterest.create(on: request.db).map { _ -> SponsorInterest in
            Task {
              do {
                try await EmailService.sendSponsorInterestConfirmation(
                  to: user, interest: sponsorInterest, on: request)
              } catch {
                request.logger.error("Failed to send sponsor interest confirmation email: \(error)")
              }
            }
            return sponsorInterest
          }
        } catch {
          return request.eventLoop.makeFailedFuture(error)
        }
      }
  }

  func allGiftBasketInterests(request: Request, _: NoArguments) throws -> EventLoopFuture<
    [GiftBasketInterest]
  > {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.forbidden) }
    return GiftBasketInterest.query(on: request.db).all()
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

        return Cart.query(on: req.db)
          .filter(\.$user.$id == userId)
          .count()
          .flatMap { cartCount in
            let cart = Cart(userID: userId, status: .open)
            return cart.create(on: req.db).flatMap { _ in
              guard cartCount == 0 else {
                return req.eventLoop.makeSucceededFuture(cart)
              }

              // Only seed a default ticket when this is the user's very first cart
              return User.find(userId, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { user in
                  let ticket = Ticket(
                    ownerID: userId, attendeeFirst: user.firstName, attendeeLast: user.lastName,
                    state: .onHold, canRemove: false)
                  ticket.$cart.id = cart.id
                  return ticket.create(on: req.db).map { _ in cart }
                }
            }
          }
      }
  }

  // MARK: - Cart queries
  // myCart: READ-ONLY query that returns existing cart (if any) regardless of status
  func myCart(request: Request, _: NoArguments) throws -> EventLoopFuture<Cart?> {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }

    // Prefer returning the user's open cart when one exists, otherwise fall back to the
    // most recently updated cart (regardless of status) so returning users see their latest data.
    return Cart.query(on: request.db)
      .filter(\.$user.$id == userId)
      .sort(\.$updatedAt, .descending)
      .sort(\.$createdAt, .descending)
      .all()
      .map { carts in
        carts.first(where: { $0.status == .open }) ?? carts.first
      }
  }

  // MARK: - Cart mutations
  // getOrCreateCart: MUTATION that creates a new cart if none exists, or returns existing open cart
  func getOrCreateCart(request: Request, _: NoArguments) throws -> EventLoopFuture<Cart> {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request)
  }

  func addTicketToCart(request: Request, arguments: AddTicketToCartArguments) throws
    -> EventLoopFuture<Ticket>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      let ticket = Ticket(
        ownerID: userId, attendeeFirst: arguments.attendeeFirst,
        attendeeLast: arguments.attendeeLast, state: .onHold, canRemove: true)
      ticket.$cart.id = cart.id
      return ticket.create(on: request.db).map { ticket }
    }
  }

  func addHorseToCart(request: Request, arguments: AddHorseToCartArguments) throws
    -> EventLoopFuture<Horse>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    // Ensure one horse per user per round
    return Horse.query(on: request.db)
      .filter(\.$owner.$id == userId)
      .filter(\.$round.$id == arguments.roundId)
      .count()
      .flatMap { userCount in
        guard userCount == 0 else {
          return request.eventLoop.makeFailedFuture(
            Abort(.conflict, reason: "User already has a horse in this round"))
            as EventLoopFuture<Horse>
        }
        // Ensure lane is not taken in that round
        return Horse.query(on: request.db)
          .filter(\.$round.$id == arguments.roundId)
          .filter(\.$lane.$id == arguments.laneId)
          .count()
          .flatMap { laneCount in
            guard laneCount == 0 else {
              return request.eventLoop.makeFailedFuture(
                Abort(.conflict, reason: "Lane is already occupied in this round"))
                as EventLoopFuture<Horse>
            }
            return self.getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
              let horse = Horse(
                ownerID: userId, roundID: arguments.roundId, laneID: arguments.laneId,
                horseName: arguments.horseName, ownershipLabel: arguments.ownershipLabel,
                state: .onHold)
              horse.$cart.id = cart.id
              return horse.create(on: request.db).map { horse }
            }
          }
      }
  }

  func addSponsorToCart(request: Request, arguments: AddSponsorToCartArguments) throws
    -> EventLoopFuture<SponsorInterest>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    guard arguments.amountCents >= Pricing.minimumSponsorCents else {
      return request.eventLoop.makeFailedFuture(
        Abort(.badRequest, reason: "Minimum sponsorship is $100"))
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      let si = SponsorInterest(
        userID: userId, companyName: arguments.companyName, amountCents: arguments.amountCents,
        companyLogoBase64: arguments.companyLogoBase64)
      si.$cart.id = cart.id
      return si.create(on: request.db).map { si }
    }
  }

  func addGiftBasketToCart(request: Request, arguments: AddGiftBasketToCartArguments) throws
    -> EventLoopFuture<GiftBasketInterest>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      let gi = GiftBasketInterest(userID: userId, descriptionText: arguments.description)
      gi.$cart.id = cart.id
      return gi.create(on: request.db).map { gi }
    }
  }

  func removeTicketFromCart(request: Request, arguments: RemoveTicketFromCartArguments) throws
    -> EventLoopFuture<Bool>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      Ticket.query(on: request.db)
        .filter(\.$id == arguments.ticketId)
        .filter(\.$cart.$id == cart.id!)
        .first()
        .unwrap(or: Abort(.notFound))
        .flatMap { t in t.delete(on: request.db).map { true } }
    }
  }

  func removeHorseFromCart(request: Request, arguments: RemoveHorseFromCartArguments) throws
    -> EventLoopFuture<Bool>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      Horse.query(on: request.db)
        .filter(\.$id == arguments.horseId)
        .filter(\.$cart.$id == cart.id!)
        .first()
        .unwrap(or: Abort(.notFound))
        .flatMap { h in h.delete(on: request.db).map { true } }
    }
  }

  func removeSponsorFromCart(request: Request, arguments: RemoveSponsorFromCartArguments) throws
    -> EventLoopFuture<Bool>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      SponsorInterest.query(on: request.db)
        .filter(\.$id == arguments.sponsorId)
        .filter(\.$cart.$id == cart.id!)
        .first()
        .unwrap(or: Abort(.notFound))
        .flatMap { s in s.delete(on: request.db).map { true } }
    }
  }

  func removeGiftBasketFromCart(request: Request, arguments: RemoveGiftBasketFromCartArguments)
    throws -> EventLoopFuture<Bool>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      GiftBasketInterest.query(on: request.db)
        .filter(\.$id == arguments.giftId)
        .filter(\.$cart.$id == cart.id!)
        .first()
        .unwrap(or: Abort(.notFound))
        .flatMap { g in g.delete(on: request.db).map { true } }
    }
  }

  func adminRemoveTicket(request: Request, arguments: AdminRemoveTicketArguments) throws
    -> EventLoopFuture<Bool>
  {
    guard let admin = request.auth.get(User.self), admin.isAdmin else { throw Abort(.forbidden) }
    return Ticket.find(arguments.ticketId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { ticket in
        let cartId = ticket.$cart.id
        return ticket.delete(on: request.db).flatMap {
          guard let cartId = cartId else {
            return request.eventLoop.makeSucceededFuture(true)
          }
          return Cart.find(cartId, on: request.db).flatMap { cart in
            guard let cart = cart, cart.status == .checkedOut else {
              return request.eventLoop.makeSucceededFuture(true)
            }
            return Payment.query(on: request.db)
              .filter(\.$cart.$id == cartId)
              .first()
              .flatMap { payment in
                guard let payment = payment else {
                  return request.eventLoop.makeSucceededFuture(true)
                }
                payment.totalCents = max(0, payment.totalCents - Pricing.ticketPriceCents)
                return payment.save(on: request.db).map { true }
              }
          }
        }
      }
  }

  func adminRemoveHorse(request: Request, arguments: AdminRemoveHorseArguments) throws
    -> EventLoopFuture<Bool>
  {
    guard let admin = request.auth.get(User.self), admin.isAdmin else { throw Abort(.forbidden) }
    return Horse.find(arguments.horseId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { horse in
        let cartId = horse.$cart.id
        return horse.delete(on: request.db).flatMap {
          guard let cartId = cartId else {
            return request.eventLoop.makeSucceededFuture(true)
          }
          return Cart.find(cartId, on: request.db).flatMap { cart in
            guard let cart = cart, cart.status == .checkedOut else {
              return request.eventLoop.makeSucceededFuture(true)
            }
            return Payment.query(on: request.db)
              .filter(\.$cart.$id == cartId)
              .first()
              .flatMap { payment in
                guard let payment = payment else {
                  return request.eventLoop.makeSucceededFuture(true)
                }
                payment.totalCents = max(0, payment.totalCents - Pricing.horsePriceCents)
                return payment.save(on: request.db).map { true }
              }
          }
        }
      }
  }

  func renameHorse(request: Request, arguments: RenameHorseArguments) throws -> EventLoopFuture<
    Horse
  > {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return Horse.find(arguments.horseId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { horse in
        guard horse.$owner.id == userId else {
          return request.eventLoop.makeFailedFuture(
            Abort(.forbidden, reason: "Cannot modify a horse you do not own"))
            as EventLoopFuture<Horse>
        }
        horse.horseName = arguments.horseName
        horse.ownershipLabel = arguments.ownershipLabel
        return horse.save(on: request.db).map { horse }
      }
  }

  func setTicketSeatingPreference(request: Request, arguments: SetTicketSeatingPreferenceArguments)
    throws -> EventLoopFuture<Ticket>
  {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return Ticket.find(arguments.ticketId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { ticket in
        guard ticket.$owner.id == userId else {
          return request.eventLoop.makeFailedFuture(
            Abort(.forbidden, reason: "Cannot modify a ticket you do not own"))
            as EventLoopFuture<Ticket>
        }
        ticket.seatingPreference = arguments.seatingPreference
        return ticket.save(on: request.db).map { ticket }
      }
  }

  func setTicketSeatAssignment(request: Request, arguments: SetTicketSeatAssignmentArguments) throws
    -> EventLoopFuture<Ticket>
  {
    guard let user = request.auth.get(User.self), user.isAdmin else { throw Abort(.unauthorized) }
    return Ticket.find(arguments.ticketId, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { ticket in
        ticket.seatAssignment = arguments.seatAssignment
        return ticket.save(on: request.db).map { ticket }
      }
  }

  func checkoutCart(request: Request, _: NoArguments) throws -> EventLoopFuture<Payment> {
    guard let user = request.auth.get(User.self), let userId = user.id else {
      throw Abort(.unauthorized)
    }
    return getOrCreateOpenCart(for: userId, on: request).flatMap { cart in
      // Load counts
      let ticketsFut = Ticket.query(on: request.db).filter(\.$cart.$id == cart.id!).count()
      let horsesFut = Horse.query(on: request.db).filter(\.$cart.$id == cart.id!).count()
      let sponsorsFut = SponsorInterest.query(on: request.db).filter(\.$cart.$id == cart.id!).all()

      return ticketsFut.and(horsesFut).and(sponsorsFut).flatMap { th, sponsors in
        let (ticketsCount, horsesCount) = th
        let sponsorCents = sponsors.reduce(0) { $0 + $1.amountCents }
        let total =
          ticketsCount * Pricing.ticketPriceCents + horsesCount * Pricing.horsePriceCents
          + sponsorCents

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

        let payment = Payment(userID: userId, cartID: cart.id, totalCents: total)

        return updateTickets.flatMap { _ in
          updateHorses.flatMap { _ in
            payment.create(on: request.db).flatMap {
              cart.status = .checkedOut
              return cart.save(on: request.db).flatMap { _ in
                Task {
                  do {
                    try await EmailService.sendHorseRacingCheckout(
                      for: cart, user: user, on: request)
                  } catch {
                    request.logger.error("Failed to send checkout email: \(error)")
                  }
                }
                return request.eventLoop.makeSucceededFuture(payment)
              }
            }
          }
        }
      }
    }
  }

  // MARK: - Authentication
  func login(request: Request, arguments: LoginArguments) throws -> EventLoopFuture<LoginPayload> {
    let email = arguments.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    guard !email.isEmpty else { throw Abort(.badRequest, reason: "Email required") }

    return User.query(on: request.db)
      .filter(\.$email == email)
      .first()
      .flatMap { user -> EventLoopFuture<LoginPayload> in
        guard let user = user, let userID = user.id else {
          return request.eventLoop.makeFailedFuture(
            Abort(.notFound, reason: "No account found for this email"))
        }

        // Admins get 7-day tokens, regular users get 30-minute tokens
        let expiresInMinutes = user.isAdmin ? (7 * 24 * 60) : 30
        let token = AuthService.generateSecureLoginToken(
          for: userID, expiresInMinutes: expiresInMinutes)
        return token.create(on: request.db).flatMap { _ in
          // Check if request is from iOS app by looking for X-Client-Platform header
          let isMobileClient = request.headers["X-Client-Platform"].first == "ios"

          // Use deep link URL for mobile clients, regular URL for web
          let host =
            isMobileClient
            ? "https://horses.noahbrave.org"
            : (Environment.get("APP_HOST") ?? "http://localhost:5173")
          var link = "\(host)/auth?token=\(token.token)"
          if let redirect = arguments.redirectTo?.trimmingCharacters(in: .whitespacesAndNewlines),
            !redirect.isEmpty
          {
            // Only allow relative paths to prevent open redirect
            if redirect.hasPrefix("/") && !redirect.hasPrefix("//") {
              let encoded =
                redirect.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? redirect
              link += "&redirectTo=\(encoded)"
            } else {
              request.logger.warning("Rejected non-relative redirectTo: \(redirect)")
            }
          }

          // Send magic link email
          Task {
            do {
              try await EmailService.sendLoginMagicLink(
                to: user,
                magicLinkURL: link,
                expiresInMinutes: expiresInMinutes,
                on: request
              )
              request.logger.info("Magic link email sent to \(email)")
            } catch {
              request.logger.error("Failed to send magic link email: \(error)")
              // Clean up the token if email fails
              try? await token.delete(on: request.db)
            }
          }

          return request.eventLoop.makeSucceededFuture(
            LoginPayload(
              success: true,
              message: "Magic link sent to \(email)",
              tokenId: token.id?.uuidString ?? ""
            ))
        }
      }
  }

  func validateToken(request: Request, arguments: ValidateTokenArguments) throws -> EventLoopFuture<
    ValidateTokenPayload
  > {
    let tokenValue = arguments.token

    return LoginToken.query(on: request.db)
      .filter(\.$token == tokenValue)
      .first()
      .flatMap { loginToken -> EventLoopFuture<ValidateTokenPayload> in
        guard let loginToken = loginToken else {
          return request.eventLoop.makeSucceededFuture(
            ValidateTokenPayload(
              success: false,
              user: nil,
              message: "Invalid token"
            ))
        }

        guard loginToken.expiresAt > Date() else {
          // Token expired, clean it up
          return loginToken.delete(on: request.db).flatMap { _ in
            request.eventLoop.makeSucceededFuture(
              ValidateTokenPayload(
                success: false,
                user: nil,
                message: "Token expired"
              ))
          }
        }

        // Get user and authenticate
        return loginToken.$user.get(on: request.db).flatMap { user in
          // Set authenticated user in session
          self.setAuthenticatedUser(request, user: user)

          // Clean up the token
          // return loginToken.delete(on: request.db).map { _ in
          //     ValidateTokenPayload(
          //         success: true,
          //         user: user,
          //         message: "Authentication successful"
          //     )
          // }
          return request.eventLoop.makeSucceededFuture(
            ValidateTokenPayload(
              success: true,
              user: user,
              message: "Authentication successful"
            ))
        }
      }
  }

  func logout(request: Request, _: NoArguments) throws -> LogoutPayload {
    // Clear session and auth
    request.auth.logout(User.self)
    request.session.destroy()
    return LogoutPayload(success: true, message: "Logged out")
  }

  // MARK: - Field resolvers
  static func cartCost(cart: Cart) -> (Request, NoArguments, EventLoopGroup) throws ->
    EventLoopFuture<CartCost>
  {
    return { req, _, _ in
      let ticketsFut = Ticket.query(on: req.db).filter(\.$cart.$id == cart.id!).count()
      let horsesFut = Horse.query(on: req.db).filter(\.$cart.$id == cart.id!).count()
      let sponsorsFut = SponsorInterest.query(on: req.db).filter(\.$cart.$id == cart.id!).all()
      return ticketsFut.and(horsesFut).and(sponsorsFut).map { th, sponsors in
        let (ticketsCount, horsesCount) = th
        let ticketsCents = ticketsCount * Pricing.ticketPriceCents
        let horseCents = horsesCount * Pricing.horsePriceCents
        let sponsorCents = sponsors.reduce(0) { $0 + $1.amountCents }
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

  static func venmoLink(cart: Cart) -> (Request, NoArguments, EventLoopGroup) throws ->
    EventLoopFuture<String>
  {
    return { req, _, _ in
      let ticketsFut = Ticket.query(on: req.db).filter(\.$cart.$id == cart.id!).count()
      let horsesFut = Horse.query(on: req.db).filter(\.$cart.$id == cart.id!).count()
      let sponsorsFut = SponsorInterest.query(on: req.db).filter(\.$cart.$id == cart.id!).all()
      let giftBasketsFut = GiftBasketInterest.query(on: req.db).filter(\.$cart.$id == cart.id!)
        .count()

      return ticketsFut.and(horsesFut).and(sponsorsFut).and(giftBasketsFut).map { result in
        let (((ticketsCount, horsesCount), sponsors), giftBasketsCount) = result
        let sponsorCents = sponsors.reduce(0) { $0 + $1.amountCents }
        let totalCents = Pricing.calculateTotalCents(
          horseCount: horsesCount,
          ticketCount: ticketsCount,
          sponsorCents: sponsorCents,
          giftBasketCount: giftBasketsCount
        )

        let orderNumber = cart.orderNumber
        return VenmoLinkService.generatePaymentLink(
          totalCents: totalCents, orderNumber: orderNumber)
      }
    }
  }
  // Users
  func createUser(request: Request, arguments: CreateUserArguments) throws -> EventLoopFuture<User>
  {
    let email = arguments.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    guard !email.isEmpty else { throw Abort(.badRequest, reason: "Email required") }

    // Check if user already exists
    return User.query(on: request.db)
      .filter(\.$email == email)
      .first()
      .flatMap { existingUser -> EventLoopFuture<User> in
        if existingUser != nil {
          return request.eventLoop.makeFailedFuture(
            Abort(
              .conflict,
              reason:
                "User with this email already exists. Click 'Login' below and we will email you a link to continue."
            ))
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
  private func updatePaymentTotal(request: Request, userID: UUID, additionalCents: Int)
    -> EventLoopFuture<Void>
  {
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
  static func ticketCost(ticket: Ticket) -> (Request, NoArguments, EventLoopGroup) throws ->
    EventLoopFuture<Int>
  {
    return { req, _, _ in
      return req.eventLoop.makeSucceededFuture(Pricing.ticketPriceCents)
    }
  }

  static func horseCost(horse: Horse) -> (Request, NoArguments, EventLoopGroup) throws ->
    EventLoopFuture<Int>
  {
    return { req, _, _ in
      return req.eventLoop.makeSucceededFuture(Pricing.horsePriceCents)
    }
  }

  static func sponsorCost(sponsor: SponsorInterest) -> (Request, NoArguments, EventLoopGroup) throws
    -> EventLoopFuture<Int>
  {
    return { req, _, _ in
      return req.eventLoop.makeSucceededFuture(sponsor.amountCents)
    }
  }

  static func giftBasketCost(giftBasket: GiftBasketInterest) -> (
    Request, NoArguments, EventLoopGroup
  ) throws -> EventLoopFuture<Int> {
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

  struct SubmitSponsorInterestArguments: Codable {
    let name: String
    let email: String
    let companyName: String
    let amountUsd: Double
    let companyLogoBase64: String?
  }

  struct GiftBasketInterestArguments: Codable {
    let description: String
  }

  struct SetPaymentReceivedArguments: Codable {
    let paymentId: UUID
    let received: Bool
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
    let amountCents: Int
    let companyLogoBase64: String?
  }

  struct AddGiftBasketToCartArguments: Codable {
    let description: String
  }

  struct RemoveTicketFromCartArguments: Codable { let ticketId: UUID }
  struct RemoveHorseFromCartArguments: Codable { let horseId: UUID }
  struct RemoveSponsorFromCartArguments: Codable { let sponsorId: UUID }
  struct AdminRemoveSponsorInterestArguments: Codable { let sponsorInterestId: UUID }
  struct AdminUpdateSponsorLogoArguments: Codable {
    let sponsorInterestId: UUID
    let companyLogoBase64: String?
  }
  struct RemoveGiftBasketFromCartArguments: Codable { let giftId: UUID }
  struct AdminRemoveTicketArguments: Codable { let ticketId: UUID }
  struct AdminRemoveHorseArguments: Codable { let horseId: UUID }
  struct RenameHorseArguments: Codable {
    let horseId: UUID
    let horseName: String
    let ownershipLabel: String
  }
  struct SetTicketSeatingPreferenceArguments: Codable {
    let ticketId: UUID
    let seatingPreference: String?
  }
  struct SetTicketSeatAssignmentArguments: Codable {
    let ticketId: UUID
    let seatAssignment: String?
  }

  // Authentication
  struct LoginArguments: Codable {
    let email: String
    let redirectTo: String?
  }

  struct LoginPayload: Codable {
    let success: Bool
    let message: String
    let tokenId: String
  }

  struct ValidateTokenArguments: Codable {
    let token: String
  }

  struct ValidateTokenPayload: Codable {
    let success: Bool
    let user: User?
    let message: String
  }

  struct LogoutPayload: Codable {
    let success: Bool
    let message: String
  }

  struct CartCost: Codable {
    let ticketsCents: Int
    let horseCents: Int
    let sponsorCents: Int
    let totalCents: Int
  }

  struct SetUserAdminArguments: Codable {
    let userId: UUID
    let isAdmin: Bool
  }

  struct ReleaseHorseArguments: Codable { let horseId: UUID }

  struct ReleaseCartArguments: Codable { let cartId: UUID }
  struct UserIdArguments: Codable { let userId: UUID }

  struct AdminStats: Codable {
    let ticketCount: Int
    let sponsorCount: Int
    let giftBasketCount: Int
  }

  // MARK: - Ticket Scanning

  struct ScanTicketPayload: Codable {
    let success: Bool
    let message: String
    let ticket: Ticket?
    let alreadyScanned: Bool
    let previousScan: TicketScan?
  }

  struct ScanningStats: Codable {
    let totalScanned: Int
    let totalTickets: Int
    let recentScans: [TicketScan]
  }

  struct ScanTicketArguments: Codable {
    let ticketId: UUID
    let scanLocation: String?
    let deviceInfo: String?
  }

  struct UndoScanArguments: Codable {
    let scanId: UUID
  }

  struct TicketByBarcodeArguments: Codable {
    let barcode: String
  }

  struct RecentScansArguments: Codable {
    let limit: Int
  }

  struct RequestHorseAudioArguments: Codable {
    let ticketId: UUID
  }

  // MARK: - Scanning Resolver Methods

  func scanTicket(request: Request, arguments: ScanTicketArguments) throws -> EventLoopFuture<
    ScanTicketPayload
  > {
    // Check if user is authenticated and is admin
    guard let user = request.auth.get(User.self), user.isAdmin else {
      throw Abort(.unauthorized, reason: "Admin authentication required")
    }

    // Find the ticket
    return Ticket.find(arguments.ticketId, on: request.db)
      .unwrap(or: Abort(.notFound, reason: "Ticket not found"))
      .flatMap { ticket in
        // Check if ticket is already scanned
        return TicketScan.query(on: request.db)
          .filter(\.$ticket.$id == arguments.ticketId)
          .first()
          .flatMap { existingScan in
            if let existingScan = existingScan {
              return request.eventLoop.makeSucceededFuture(
                ScanTicketPayload(
                  success: false,
                  message: "Ticket already scanned",
                  ticket: ticket,
                  alreadyScanned: true,
                  previousScan: existingScan
                ))
            }

            // Create new scan record
            // Get user ID safely
            guard let userId = user.id else {
              return request.eventLoop.makeFailedFuture(
                Abort(.internalServerError, reason: "User ID not available"))
            }

            let scan = TicketScan(
              ticketID: arguments.ticketId,
              scannerUserID: userId,
              scanLocation: arguments.scanLocation,
              deviceInfo: arguments.deviceInfo
            )

            return scan.save(on: request.db)
              .flatMap { _ in
                // Update ticket with scan timestamp
                ticket.scannedAt = Date()
                ticket.$scannedBy.id = user.id
                ticket.scanLocation = arguments.scanLocation

                return ticket.save(on: request.db)
                  .map { _ in
                    ScanTicketPayload(
                      success: true,
                      message: "Ticket scanned successfully",
                      ticket: ticket,
                      alreadyScanned: false,
                      previousScan: nil
                    )
                  }
              }
          }
      }
  }

  func undoScan(request: Request, arguments: UndoScanArguments) throws -> EventLoopFuture<
    ScanTicketPayload
  > {
    // Check if user is authenticated and is admin
    guard let user = request.auth.get(User.self), user.isAdmin else {
      throw Abort(.unauthorized, reason: "Admin authentication required")
    }

    return TicketScan.find(arguments.scanId, on: request.db)
      .unwrap(or: Abort(.notFound, reason: "Scan record not found"))
      .flatMap { scan in
        // Get the ticket
        return scan.$ticket.get(on: request.db)
          .flatMap { ticket in
            // Delete the scan record
            return scan.delete(on: request.db)
              .flatMap { _ in
                // Clear scan data from ticket
                ticket.scannedAt = nil
                ticket.$scannedBy.id = nil
                ticket.scanLocation = nil

                return ticket.save(on: request.db)
                  .map { _ in
                    ScanTicketPayload(
                      success: true,
                      message: "Scan undone successfully",
                      ticket: ticket,
                      alreadyScanned: false,
                      previousScan: nil
                    )
                  }
              }
          }
      }
  }

  func ticketByBarcode(request: Request, arguments: TicketByBarcodeArguments) throws
    -> EventLoopFuture<Ticket?>
  {
    // Parse barcode format: "NBT:UUID"
    guard arguments.barcode.hasPrefix("NBT:") else {
      return request.eventLoop.makeSucceededFuture(nil)
    }

    let ticketIdString = String(arguments.barcode.dropFirst(4))
    guard let ticketId = UUID(uuidString: ticketIdString) else {
      return request.eventLoop.makeSucceededFuture(nil)
    }

    return Ticket.find(ticketId, on: request.db)
  }

  func scanningStats(request: Request, _: NoArguments) throws -> EventLoopFuture<ScanningStats> {
    // Check if user is authenticated and is admin
    guard let user = request.auth.get(User.self), user.isAdmin else {
      throw Abort(.unauthorized, reason: "Admin authentication required")
    }

    let totalScanned = TicketScan.query(on: request.db).count()
    let totalTickets = Ticket.query(on: request.db).filter(\.$state == .confirmed).count()

    let recentScans = TicketScan.query(on: request.db)
      .with(\.$ticket)
      .with(\.$scanner)
      .sort(\.$scanTimestamp, .descending)
      .limit(10)
      .all()

    return totalScanned.and(totalTickets).and(recentScans)
      .map { result in
        let ((scanned, tickets), recent) = result
        return ScanningStats(
          totalScanned: scanned,
          totalTickets: tickets,
          recentScans: recent
        )
      }
  }

  func recentScans(request: Request, arguments: RecentScansArguments) throws -> EventLoopFuture<
    [TicketScan]
  > {
    // Check if user is authenticated and is admin
    guard let user = request.auth.get(User.self), user.isAdmin else {
      throw Abort(.unauthorized, reason: "Admin authentication required")
    }

    return TicketScan.query(on: request.db)
      .with(\.$ticket)
      .with(\.$scanner)
      .sort(\.$scanTimestamp, .descending)
      .limit(arguments.limit)
      .all()
  }

  func requestHorseAudio(
    request: Request,
    arguments: RequestHorseAudioArguments
  ) throws -> EventLoopFuture<HorseAudioClipPayload> {
    guard let user = request.auth.get(User.self), user.isAdmin else {
      throw Abort(.unauthorized, reason: "Admin authentication required")
    }

    return HorseAudioService.generateClip(for: arguments.ticketId, requestedBy: user, on: request)
  }
}
