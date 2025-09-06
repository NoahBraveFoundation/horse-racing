import Foundation
@preconcurrency import Graphiti
@preconcurrency import GraphQLKit
import Vapor
import NIO
import Fluent

// Definition of our GraphQL schema
let horseRacingSchema = try! Graphiti.Schema<HorseResolver, Request> {
    Scalar(UUID.self)
    Scalar(Date.self)

    Enum(HorseEntryState.self) {
        Value(.onHold)
        Value(.pendingPayment)
        Value(.confirmed)
    }
    
    Enum(CartStatus.self) {
        Value(.open)
        Value(.checkedOut)
        Value(.abandoned)
    }

    Enum(TicketState.self) {
        Value(.onHold)
        Value(.pendingPayment)
        Value(.confirmed)
    }
    
    // User type
    Type(User.self) {
        Field("id", at: \.id)
        Field("email", at: \.email)
        Field("firstName", at: \.firstName)
        Field("lastName", at: \.lastName)
        Field("isAdmin", at: \.isAdmin)
        Field("tickets", with: \.$tickets)
        Field("horses", with: \.$horses)
        Field("sponsorInterests", with: \.$sponsorInterests)
        Field("giftBasketInterests", with: \.$giftBasketInterests)
        Field("payments", with: \.$payments)
        Field("carts", with: \.$carts)
    }

    // Round type
    Type(Round.self) {
        Field("id", at: \.id)
        Field("name", at: \.name)
        Field("startAt", at: \.startAt)
        Field("endAt", at: \.endAt)
        Field("lanes", with: \.$lanes)
        Field("horses", with: \.$horses)
    }

    // Lane type
    Type(Lane.self) {
        Field("id", at: \.id)
        Field("number", at: \.number)
        Field("round", with: \.$round)
        Field("horse", with: \.$horse)
    }

    // Ticket type
    Type(Ticket.self) {
        Field("id", at: \.id)
        Field("attendeeFirst", at: \.attendeeFirst)
        Field("attendeeLast", at: \.attendeeLast)
        Field("seatingPreference", at: \.seatingPreference)
        Field("seatAssignment", at: \.seatAssignment)
        Field("owner", with: \.$owner)
        Field("state", at: \.state)
        Field("canRemove", at: \.canRemove)
        Field("costCents", at: HorseResolver.ticketCost)
    }

    // Horse type
    Type(Horse.self) {
        Field("id", at: \.id)
        Field("horseName", at: \.horseName)
        Field("ownershipLabel", at: \.ownershipLabel)
        Field("state", at: \.state)
        Field("owner", with: \.$owner)
        Field("round", with: \.$round)
        Field("lane", with: \.$lane)
        Field("costCents", at: HorseResolver.horseCost)
    }

    // Sponsor interest type
    Type(SponsorInterest.self) {
        Field("id", at: \.id)
        Field("companyName", at: \.companyName)
        Field("companyLogoBase64", at: \.companyLogoBase64)
        Field("costCents", at: HorseResolver.sponsorCost)
        Field("user", with: \.$user)
    }

    // Gift basket interest type
    Type(GiftBasketInterest.self) {
        Field("id", at: \.id)
        Field("description", at: \.descriptionText)
        Field("costCents", at: HorseResolver.giftBasketCost)
        Field("user", with: \.$user)
    }

    // LoginToken type
    Type(LoginToken.self) {
        Field("id", at: \.id)
        Field("token", at: \.token)
        Field("expiresAt", at: \.expiresAt)
        Field("user", with: \.$user)
    }

    // Payment type
    Type(Payment.self) {
        Field("id", at: \.id)
        Field("totalCents", at: \.totalCents)
        Field("paymentReceived", at: \.paymentReceived)
        Field("paymentReceivedAt", at: \.paymentReceivedAt)
        Field("user", with: \.$user)
    }

    Type(HorseResolver.AdminStats.self) {
        Field("ticketCount", at: \.ticketCount)
        Field("sponsorCount", at: \.sponsorCount)
        Field("giftBasketCount", at: \.giftBasketCount)
        Field("totalPaymentsCents", at: \.totalPaymentsCents)
    }



    // CartCost type (calculated, no database)
    Type(HorseResolver.CartCost.self) {
        Field("ticketsCents", at: \.ticketsCents)
        Field("horseCents", at: \.horseCents)
        Field("sponsorCents", at: \.sponsorCents)
        Field("totalCents", at: \.totalCents)
    }

    // Cart type
    Type(Cart.self) {
        Field("id", at: \.id)
        Field("status", at: \.status)
        Field("orderNumber", at: \.orderNumber)
        Field("user", with: \.$user)
        Field("horses", with: \.$horses)
        Field("tickets", with: \.$tickets)
        Field("sponsorInterests", with: \.$sponsorInterests)
        Field("giftBasketInterests", with: \.$giftBasketInterests)
        Field("cost", at: HorseResolver.cartCost)
        Field("venmoLink", at: HorseResolver.venmoLink)
        Field("venmoUser", at: \.venmoUser)
    }

    // Login
    Type(HorseResolver.LoginPayload.self) {
        Field("success", at: \.success)
        Field("message", at: \.message)
        Field("tokenId", at: \.tokenId)
    }
    
    // Logout
    Type(HorseResolver.LogoutPayload.self) {
        Field("success", at: \.success)
        Field("message", at: \.message)
    }
    
    // Validate Token
    Type(HorseResolver.ValidateTokenPayload.self) {
        Field("success", at: \.success)
        Field("user", at: \.user)
        Field("message", at: \.message)
    }

    // Queries
    Query {
        Field("me", at: HorseResolver.me)
        Field("rounds", at: HorseResolver.getRounds)
        Field("lanes", at: HorseResolver.getLanes) {
            Argument("roundId", at: \.roundId)
        }
        Field("paymentStatus", at: HorseResolver.getPaymentStatus)
        Field("myCart", at: HorseResolver.myCart)
        Field("user", at: HorseResolver.userById) {
            Argument("userId", at: \.userId)
        }
        Field("users", at: HorseResolver.allUsers)
        Field("payments", at: HorseResolver.payments)
        Field("allHorses", at: HorseResolver.allHorses)
        Field("allTickets", at: HorseResolver.allTickets)
        Field("abandonedCarts", at: HorseResolver.abandonedCarts)
        Field("adminStats", at: HorseResolver.adminStats)
        Field("sponsorInterests", at: HorseResolver.allSponsorInterests)
        Field("giftBasketInterests", at: HorseResolver.allGiftBasketInterests)
    }
    
    // Mutations
    Mutation {
        // Users
        Field("createUser", at: HorseResolver.createUser) {
            Argument("email", at: \.email)
            Argument("firstName", at: \.firstName)
            Argument("lastName", at: \.lastName)
        }

        // Cart ops
        Field("getOrCreateCart", at: HorseResolver.getOrCreateCart)
        Field("addTicketToCart", at: HorseResolver.addTicketToCart) {
            Argument("attendeeFirst", at: \.attendeeFirst)
            Argument("attendeeLast", at: \.attendeeLast)
        }
        Field("addHorseToCart", at: HorseResolver.addHorseToCart) {
            Argument("roundId", at: \.roundId)
            Argument("laneId", at: \.laneId)
            Argument("horseName", at: \.horseName)
            Argument("ownershipLabel", at: \.ownershipLabel)
        }
        Field("addSponsorToCart", at: HorseResolver.addSponsorToCart) {
            Argument("companyName", at: \.companyName)
            Argument("amountCents", at: \.amountCents)
            Argument("companyLogoBase64", at: \.companyLogoBase64)
        }
        Field("addGiftBasketToCart", at: HorseResolver.addGiftBasketToCart) {
            Argument("description", at: \.description)
        }

        Field("removeTicketFromCart", at: HorseResolver.removeTicketFromCart) {
            Argument("ticketId", at: \.ticketId)
        }
        Field("removeHorseFromCart", at: HorseResolver.removeHorseFromCart) {
            Argument("horseId", at: \.horseId)
        }
        Field("removeSponsorFromCart", at: HorseResolver.removeSponsorFromCart) {
            Argument("sponsorId", at: \.sponsorId)
        }
        Field("removeGiftBasketFromCart", at: HorseResolver.removeGiftBasketFromCart) {
            Argument("giftId", at: \.giftId)
        }

        Field("adminRemoveTicket", at: HorseResolver.adminRemoveTicket) {
            Argument("ticketId", at: \.ticketId)
        }
        Field("adminRemoveHorse", at: HorseResolver.adminRemoveHorse) {
            Argument("horseId", at: \.horseId)
        }

        Field("renameHorse", at: HorseResolver.renameHorse) {
            Argument("horseId", at: \.horseId)
            Argument("horseName", at: \.horseName)
            Argument("ownershipLabel", at: \.ownershipLabel)
        }

        Field("setTicketSeatingPreference", at: HorseResolver.setTicketSeatingPreference) {
            Argument("ticketId", at: \.ticketId)
            Argument("seatingPreference", at: \.seatingPreference)
        }

        Field("setTicketSeatAssignment", at: HorseResolver.setTicketSeatAssignment) {
            Argument("ticketId", at: \.ticketId)
            Argument("seatAssignment", at: \.seatAssignment)
        }

        Field("checkoutCart", at: HorseResolver.checkoutCart)

        // Authentication
        Field("login", at: HorseResolver.login) {
            Argument("email", at: \.email)
            Argument("redirectTo", at: \.redirectTo)
        }
        Field("validateToken", at: HorseResolver.validateToken) {
            Argument("token", at: \.token)
        }
        Field("logout", at: HorseResolver.logout)

        // Payment management
        Field("setPaymentReceived", at: HorseResolver.setPaymentReceived) {
            Argument("paymentId", at: \.paymentId)
            Argument("received", at: \.received)
        }
        Field("setUserAdmin", at: HorseResolver.setUserAdmin) {
            Argument("userId", at: \.userId)
            Argument("isAdmin", at: \.isAdmin)
        }
        Field("releaseHorse", at: HorseResolver.releaseHorse) {
            Argument("horseId", at: \.horseId)
        }
        Field("releaseCart", at: HorseResolver.releaseCart) {
            Argument("cartId", at: \.cartId)
        }
        Field("runAdminCleanup", at: HorseResolver.runAdminCleanup)
        Field("resetDatabase", at: HorseResolver.resetDatabase)
    }
}
