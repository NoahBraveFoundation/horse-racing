import Foundation
@preconcurrency import GraphQLKit
import Vapor
import NIO
import Fluent

// Definition of our GraphQL schema
let horseRacingSchema = try! Schema<HorseResolver, Request> {
    Scalar(UUID.self)
    Scalar(Date.self)

    Enum(HorseEntryState.self) {
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
        Field("payment", with: \.$payments)
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
        Field("owner", with: \.$owner)
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
    }

    // Sponsor interest type
    Type(SponsorInterest.self) {
        Field("id", at: \.id)
        Field("companyName", at: \.companyName)
        Field("user", with: \.$user)
    }

    // Gift basket interest type
    Type(GiftBasketInterest.self) {
        Field("id", at: \.id)
        Field("description", at: \.descriptionText)
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

    // Queries
    Query {
        Field("rounds", at: HorseResolver.getRounds)
        Field("lanes", at: HorseResolver.getLanes) {
            Argument("roundId", at: \.roundId)
        }
        Field("paymentStatus", at: HorseResolver.getPaymentStatus)
    }
    
    // Mutations
    Mutation {
        // Users
        Field("createUser", at: HorseResolver.createUser) {
            Argument("email", at: \.email)
            Argument("firstName", at: \.firstName)
            Argument("lastName", at: \.lastName)
        }

        // Tickets
        Field("purchaseTicket", at: HorseResolver.purchaseTicket) {
            Argument("attendeeFirst", at: \.attendeeFirst)
            Argument("attendeeLast", at: \.attendeeLast)
        }

        // Horse purchases
        Field("purchaseHorse", at: HorseResolver.purchaseHorse) {
            Argument("roundId", at: \.roundId)
            Argument("laneId", at: \.laneId)
            Argument("horseName", at: \.horseName)
            Argument("ownershipLabel", at: \.ownershipLabel)
        }
        Field("selectHorseLane", at: HorseResolver.selectHorseLane) {
            Argument("horseId", at: \.horseId)
            Argument("roundId", at: \.roundId)
            Argument("laneId", at: \.laneId)
        }
        Field("updateHorseState", at: HorseResolver.updateHorseState) {
            Argument("horseId", at: \.horseId)
            Argument("state", at: \.state)
        }

        // Sponsor interest
        Field("registerSponsorInterest", at: HorseResolver.registerSponsorInterest) {
            Argument("companyName", at: \.companyName)
        }

        // Gift basket interest
        Field("registerGiftBasketInterest", at: HorseResolver.registerGiftBasketInterest) {
            Argument("description", at: \.description)
        }

        // Payment management
        Field("markPaymentReceived", at: HorseResolver.markPaymentReceived) {
            Argument("paymentId", at: \.paymentId)
        }
    }
}
