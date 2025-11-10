import AVFoundation
import Dependencies
import Foundation

struct AudioPlaybackClient {
  var play: @Sendable @MainActor (Data) async throws -> Void
  var stop: @Sendable @MainActor () async -> Void
}

extension AudioPlaybackClient: DependencyKey {
  static let liveValue = AudioPlaybackClient(
    play: { data in
      try await HorseAudioPlaybackCoordinator.shared.play(data: data)
    },
    stop: {
      await HorseAudioPlaybackCoordinator.shared.stop()
    }
  )
}

extension DependencyValues {
  var audioPlaybackClient: AudioPlaybackClient {
    get { self[AudioPlaybackClient.self] }
    set { self[AudioPlaybackClient.self] = newValue }
  }
}

private final class HorseAudioPlaybackCoordinator: NSObject, AVAudioPlayerDelegate {
  @MainActor static let shared = HorseAudioPlaybackCoordinator()

  private var player: AVAudioPlayer?
  private var continuation: CheckedContinuation<Void, Error>?

  private override init() {
    super.init()
  }

  @MainActor
  private func configureSession() throws {
    let session = AVAudioSession.sharedInstance()
    try session.setCategory(.playback, mode: .spokenAudio, policy: .longFormAudio)
    try session.setActive(true, options: .notifyOthersOnDeactivation)
  }

  @MainActor
  func play(data: Data) async throws {
    await stop()

    try configureSession()

    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      Task { @MainActor in
        do {
          let player = try AVAudioPlayer(data: data)
          player.delegate = self
          player.volume = 1.0
          player.prepareToPlay()
          player.play()
          self.player = player
          self.continuation = continuation
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }

  @MainActor
  func stop() async {
    guard let player else {
      if let continuation {
        continuation.resume()
        self.continuation = nil
      }
      return
    }
    player.stop()
    self.player = nil
    continuation?.resume()
    continuation = nil
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    continuation?.resume()
    continuation = nil
    self.player = nil
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
  }
}
