import Fluent
import Foundation
import OpenAI
import Vapor

struct HorseAudioClipPayload: Content {
  let ownerName: String
  let ownerEmail: String
  let ticketAttendeeName: String
  let horseNames: [String]
  let audioBase64: String
  let prompt: String
}

struct HorseAudioService {
  static func generateClip(
    for ticketId: UUID,
    requestedBy scanner: User?,
    on request: Request
  ) -> EventLoopFuture<HorseAudioClipPayload> {
    Ticket.find(ticketId, on: request.db)
      .unwrap(or: Abort(.notFound, reason: "Ticket not found"))
      .flatMap { ticket in
        ticket.$owner.get(on: request.db).flatMap { owner in
          // Load cart and its tickets
          let cartFuture: EventLoopFuture<Cart?> = ticket.$cart.get(on: request.db)

          return cartFuture.flatMap { cart in
            // Load all tickets in the cart if available
            let ticketsFuture: EventLoopFuture<[Ticket]>
            if let cart = cart {
              ticketsFuture = cart.$tickets.query(on: request.db)
                .filter(\.$state == .confirmed)
                .all()
            } else {
              ticketsFuture = request.eventLoop.makeSucceededFuture([ticket])
            }

            return ticketsFuture.flatMap { cartTickets in
              owner.$horses
                .query(on: request.db)
                .filter(\.$state == .confirmed)
                .all()
                .flatMapThrowing { horses in
                  HorseAudioContext(
                    ticket: ticket,
                    owner: owner,
                    cartTickets: cartTickets,
                    horseNames: horses.map(\.horseName).sorted(),
                    orderNumber: cart?.orderNumber
                  )
                }
                .flatMap { context in
                  let promise = request.eventLoop.makePromise(of: HorseAudioClipPayload.self)
                  Task {
                    do {
                      let audioData = try await generateAudio(
                        for: context.prompt,
                        logger: request.logger
                      )
                      let clip = HorseAudioClipPayload(
                        ownerName: context.ownerName,
                        ownerEmail: context.ownerEmail,
                        ticketAttendeeName: context.attendeeName,
                        horseNames: context.horseNames,
                        audioBase64: audioData.base64EncodedString(),
                        prompt: context.prompt
                      )
                      promise.succeed(clip)
                    } catch {
                      promise.fail(error)
                    }
                  }
                  return promise.futureResult
                }
            }
          }
        }
      }
  }

  private static func generateAudio(for prompt: String, logger: Logger) async throws -> Data {
    guard let apiKey = Environment.get("OPENAI_API_KEY"), !apiKey.isEmpty else {
      throw Abort(
        .internalServerError,
        reason: "OPENAI_API_KEY not configured. Unable to generate horse audio."
      )
    }

    let client = OpenAI(apiToken: apiKey)
    let narrationScript = try await generateNarrationScript(
      from: prompt,
      client: client,
      logger: logger
    )
    let query = AudioSpeechQuery(
      model: .gpt_4o_mini_tts,
      input: narrationScript,
      voice: AudioSpeechQuery.AudioSpeechVoice.allCases.randomElement() ?? .alloy,
      instructions: "Sound like an arena announcer with upbeat energy",
      responseFormat: .mp3,
      speed: 1.0
    )

    logger.info("Requesting horse audio from OpenAI")
    let response = try await client.audioCreateSpeech(query: query)
    return response.audio
  }

  private static func generateNarrationScript(
    from prompt: String,
    client: OpenAI,
    logger: Logger
  ) async throws -> String {
    let systemInstructions = """
      You craft tight, energetic arena-style announcements for charity horse racing events.
      Keep scripts between 5 and 12 seconds when spoken.
      Highlight names with excitement, celebrate supporters, and embrace goofy horse racing vibes.
      """
    let chatQuery = ChatQuery(
      messages: [
        .system(.init(content: .textContent(systemInstructions))),
        .system(.init(content: .textContent(prompt))),
      ],
      model: .gpt5_nano
    )

    logger.info("Requesting narration script from GPT-5 Nano")
    let response = try await client.chats(query: chatQuery)
    guard
      let content = response.choices.first?.message.content?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ),
      !content.isEmpty
    else {
      throw Abort(.internalServerError, reason: "GPT-5 Nano returned an empty narration script.")
    }
    return content
  }
}

private struct HorseAudioContext {
  let ownerName: String
  let ownerEmail: String
  let attendeeName: String
  let horseNames: [String]
  let prompt: String

  init(
    ticket: Ticket, owner: User, cartTickets: [Ticket], horseNames: [String], orderNumber: String?
  ) {
    self.ownerName = "\(owner.firstName) \(owner.lastName)"
    self.ownerEmail = owner.email
    self.attendeeName = "\(ticket.attendeeFirst) \(ticket.attendeeLast)"
    self.horseNames = horseNames
    self.prompt = HorseAudioContext.buildPrompt(
      ownerName: ownerName,
      attendeeName: attendeeName,
      cartTickets: cartTickets,
      horseNames: horseNames,
      orderNumber: orderNumber
    )
  }

  private static func buildPrompt(
    ownerName: String,
    attendeeName: String,
    cartTickets: [Ticket],
    horseNames: [String],
    orderNumber: String?
  ) -> String {
    // Build list of all attendees from cart
    let attendeeNames =
      cartTickets
      .map { "\($0.attendeeFirst) \($0.attendeeLast)" }
      .sorted()
      .joined(separator: ", ")

    let horseList = horseNames.isEmpty ? "No horses" : horseNames.joined(separator: ", ")
    let orderInfo = orderNumber.map { "Order \($0)" } ?? ""

    return """
      Owner: \(ownerName)
      Guests: \(attendeeNames)
      \(orderInfo)
      Spotlight the horses: \(horseList)
      """
  }
}
