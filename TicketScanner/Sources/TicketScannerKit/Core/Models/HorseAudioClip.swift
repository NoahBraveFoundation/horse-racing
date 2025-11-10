import Foundation

public struct HorseAudioClip: Equatable, Sendable {
  public let ownerName: String
  public let ownerEmail: String
  public let ticketAttendeeName: String
  public let horseNames: [String]
  public let audioBase64: String
  public let prompt: String

  public init(
    ownerName: String,
    ownerEmail: String,
    ticketAttendeeName: String,
    horseNames: [String],
    audioBase64: String,
    prompt: String
  ) {
    self.ownerName = ownerName
    self.ownerEmail = ownerEmail
    self.ticketAttendeeName = ticketAttendeeName
    self.horseNames = horseNames
    self.audioBase64 = audioBase64
    self.prompt = prompt
  }

  public var title: String {
    "Horse lineup for \(ownerName)"
  }

  public var decodedAudioData: Data? {
    Data(base64Encoded: audioBase64)
  }
}
