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
                    logger: request.logger
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

  private static func generateAudio(for script: String, logger: Logger) async throws -> Data {
    guard let apiKey = Environment.get("OPENAI_API_KEY"), !apiKey.isEmpty else {
      throw Abort(
        .internalServerError,
        reason: "OPENAI_API_KEY not configured. Unable to generate horse audio."
      )
    }

    let client = OpenAI(apiToken: apiKey)
    let query = AudioSpeechQuery(
      model: .gpt_4o_mini_tts,
      input: script,
      voice: AudioSpeechQuery.AudioSpeechVoice.allCases.randomElement() ?? .alloy,
      instructions: "Sound like an arena announcer with upbeat energy",
      responseFormat: .mp3,
      speed: 1.0
    )

    logger.info("Requesting horse audio from OpenAI")
    let response = try await client.audioCreateSpeech(query: query)
    return response.audio
  }
}

private struct HorseAudioTemplate: Decodable {
  let id: String
  let text: String

  func render(ownerName: String, guestNames: [String], horseNames: [String]) -> String {
    let guestDescription = HorseAudioTemplate.describeList(guestNames) ?? "their crew"
    let horseDescription = HorseAudioTemplate.describeList(horseNames) ?? "their entries"
    let partyDescription =
      guestNames.isEmpty
      ? ownerName
      : "\(ownerName) with \(guestDescription)"

    var script = text
    let replacements: [String: String] = [
      "{{owner}}": ownerName,
      "{{guests}}": guestDescription,
      "{{party}}": partyDescription,
      "{{horses}}": horseDescription,
    ]

    replacements.forEach { key, value in
      script = script.replacingOccurrences(of: key, with: value)
    }

    return script
  }

  static func describeList(_ values: [String]) -> String? {
    guard !values.isEmpty else { return nil }
    if values.count == 1 {
      return values[0]
    } else if values.count == 2 {
      return "\(values[0]) and \(values[1])"
    }
    let leading = values.dropLast().joined(separator: ", ")
    return "\(leading), and \(values.last!)"
  }
}

private enum HorseAudioTemplates {
  private static let templatesResult: Result<[HorseAudioTemplate], Error> = {
    do {
      guard
        let url = Bundle.module.url(forResource: "horse-audio-templates", withExtension: "json")
      else {
        throw Abort(
          .internalServerError, reason: "horse-audio-templates.json missing from resources.")
      }

      let data = try Data(contentsOf: url)
      let templates = try JSONDecoder().decode([HorseAudioTemplate].self, from: data)
      return .success(templates)
    } catch {
      return .failure(error)
    }
  }()

  static func script(
    ownerName: String,
    guestNames: [String],
    horseNames: [String],
    logger: Logger?
  ) -> String {
    let fallback = fallbackScript(
      ownerName: ownerName, guestNames: guestNames, horseNames: horseNames)
    do {
      let template = try randomTemplate()
      return template.render(ownerName: ownerName, guestNames: guestNames, horseNames: horseNames)
    } catch {
      logger?.error("Horse audio template error: \(error.localizedDescription)")
      return fallback
    }
  }

  private static func randomTemplate() throws -> HorseAudioTemplate {
    let templates = try loadTemplates()
    guard let template = templates.randomElement() else {
      throw Abort(.internalServerError, reason: "No horse audio templates configured.")
    }
    return template
  }

  private static func loadTemplates() throws -> [HorseAudioTemplate] {
    try templatesResult.get()
  }

  private static func fallbackScript(
    ownerName: String,
    guestNames: [String],
    horseNames: [String]
  ) -> String {
    let guestDescription = HorseAudioTemplate.describeList(guestNames) ?? "their cheering crew"
    let horseDescription = HorseAudioTemplate.describeList(horseNames) ?? "their entries"
    return "Let's make noise for \(ownerName) with \(guestDescription) backing \(horseDescription)!"
  }
}

private struct HorseAudioContext {
  let ownerName: String
  let ownerEmail: String
  let attendeeName: String
  let horseNames: [String]
  let prompt: String

  init(
    ticket: Ticket, owner: User, cartTickets: [Ticket], horseNames: [String], logger: Logger?
  ) {
    self.ownerName = "\(owner.firstName) \(owner.lastName)"
    self.ownerEmail = owner.email
    self.attendeeName = "\(ticket.attendeeFirst) \(ticket.attendeeLast)"
    self.horseNames = horseNames
    let guestNames = HorseAudioContext.buildGuestList(
      ownerName: ownerName, cartTickets: cartTickets)
    self.prompt = HorseAudioContext.buildPrompt(
      ownerName: ownerName,
      guestNames: guestNames,
      horseNames: horseNames,
      logger: logger
    )
  }

  private static func buildPrompt(
    ownerName: String,
    guestNames: [String],
    horseNames: [String],
    logger: Logger?
  ) -> String {
    HorseAudioTemplates.script(
      ownerName: ownerName,
      guestNames: guestNames,
      horseNames: horseNames,
      logger: logger
    )
  }

  private static func buildGuestList(ownerName: String, cartTickets: [Ticket]) -> [String] {
    cartTickets
      .map { "\($0.attendeeFirst) \($0.attendeeLast)" }
      .filter { $0 != ownerName }
      .sorted()
  }
}
