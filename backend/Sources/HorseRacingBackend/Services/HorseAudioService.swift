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
          owner.$horses
            .query(on: request.db)
            .filter(\.$state == .confirmed)
            .all()
            .flatMapThrowing { horses in
              HorseAudioContext(
                ticket: ticket,
                owner: owner,
                horseNames: horses.map(\.horseName).sorted()
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

  private static func generateAudio(for prompt: String, logger: Logger) async throws -> Data {
    guard let apiKey = Environment.get("OPENAI_API_KEY"), !apiKey.isEmpty else {
      throw Abort(
        .internalServerError,
        reason: "OPENAI_API_KEY not configured. Unable to generate horse audio."
      )
    }

    let client = OpenAI(apiToken: apiKey)
    let query = AudioSpeechQuery(
      model: .gpt_4o_mini_tts,
      input: prompt,
      voice: AudioSpeechQuery.AudioSpeechVoice.allCases.randomElement() ?? .alloy,
      instructions: "Sound like an arena announcer with upbeat energy",
      responseFormat: .mp3,
      speed: 1.5
    )

    logger.info("Requesting horse audio from OpenAI")
    let response = try await client.audioCreateSpeech(query: query)
    return response.audio
  }
}

private struct HorseAudioContext {
  let ownerName: String
  let ownerEmail: String
  let attendeeName: String
  let horseNames: [String]
  let prompt: String

  init(ticket: Ticket, owner: User, horseNames: [String]) {
    self.ownerName = "\(owner.firstName) \(owner.lastName)"
    self.ownerEmail = owner.email
    self.attendeeName = "\(ticket.attendeeFirst) \(ticket.attendeeLast)"
    self.horseNames = horseNames
    self.prompt = HorseAudioContext.buildPrompt(
      ownerName: ownerName,
      attendeeName: attendeeName,
      horseNames: horseNames
    )
  }

  private static func buildPrompt(
    ownerName: String,
    attendeeName: String,
    horseNames: [String]
  ) -> String {
    if horseNames.isEmpty {
      return """
        Record a high-energy 12 second announcement celebrating guest \(attendeeName).
        Congratulate them on supporting the NoahBRAVE Foundation and cheer on their night at the races.
        Keep the tone fun, exciting, and stadium-ready.
        """
    }

    let horseList = horseNames.joined(separator: ", ")
    return """
      Create a lively 15 second audio hype message for \(ownerName) and guest \(attendeeName).
      Spotlight the horses: \(horseList).
      Mention the NoahBRAVE Foundation and make it sound like an arena announcer with upbeat energy.
      """
  }
}
