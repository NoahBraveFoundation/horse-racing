import AVFoundation
import Dependencies
import Logging
import Sharing
import UIKit

struct ScanFeedbackClient {
  var playSuccess: @Sendable @MainActor () -> Void
  var playFailure: @Sendable @MainActor () -> Void
}

extension ScanFeedbackClient: DependencyKey {
  static let liveValue = ScanFeedbackClient(
    playSuccess: {
      ScanFeedbackCoordinator.shared.play(.success)
    },
    playFailure: {
      ScanFeedbackCoordinator.shared.play(.failure)
    }
  )
}

extension DependencyValues {
  var scanFeedbackClient: ScanFeedbackClient {
    get { self[ScanFeedbackClient.self] }
    set { self[ScanFeedbackClient.self] = newValue }
  }
}

@MainActor
private final class ScanFeedbackCoordinator {
  enum FeedbackType {
    case success
    case failure
  }

  static let shared = ScanFeedbackCoordinator()

  private let logger = Logger(label: "org.noahbrave.ticket-scanner.scan-feedback")

  private var successPlayer: AVAudioPlayer?
  private var failurePlayer: AVAudioPlayer?
  private var isAudioSessionConfigured = false
  @SharedReader(.appStorage(SharedStorageKey.hapticsEnabled))
  private var hapticsEnabled: Bool = true
  @SharedReader(.appStorage(SharedStorageKey.audioFeedbackEnabled))
  private var audioFeedbackEnabled: Bool = true

  private init() {
    successPlayer = loadPlayer(named: "success")
    failurePlayer = loadPlayer(named: "failure")
  }

  func play(_ type: FeedbackType) {
    logger.debug("Playing scan feedback: \(type.debugLabel)")
    if hapticsEnabled {
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      switch type {
      case .success:
        generator.notificationOccurred(.success)
      case .failure:
        generator.notificationOccurred(.error)
      }
    }

    guard audioFeedbackEnabled else { return }

    switch type {
    case .success:
      play(player: successPlayer, type: type)
    case .failure:
      play(player: failurePlayer, type: type)
    }
  }

  private func loadPlayer(named: String) -> AVAudioPlayer? {
    guard let url = Bundle.main.url(forResource: named, withExtension: "wav") else {
      logger.warning("Missing scan feedback sound resource: \(named).wav")
      return nil
    }

    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.prepareToPlay()
      logger.debug("Loaded scan feedback sound \(named).wav")
      return player
    } catch {
      logger.error("Failed to load scan feedback sound \(named).wav: \(error.localizedDescription)")
      return nil
    }
  }

  private func configureAudioSessionIfNeeded() {
    guard !isAudioSessionConfigured else { return }
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
      isAudioSessionConfigured = true
    } catch {
      logger.error(
        "Failed to configure audio session for scan feedback: \(error.localizedDescription)")
    }
  }

  private func play(player: AVAudioPlayer?, type: FeedbackType) {
    guard let player else {
      logger.error("Attempted to play scan feedback before player was loaded: \(type.debugLabel)")
      return
    }

    configureAudioSessionIfNeeded()

    if player.isPlaying {
      player.currentTime = 0
    }

    player.volume = 1.0
    do {
      try AVAudioSession.sharedInstance().setActive(true, options: [.notifyOthersOnDeactivation])
    } catch {
      logger.error(
        "Failed to activate audio session for scan feedback: \(error.localizedDescription)")
    }

    if !player.play() {
      logger.error("Failed to start scan feedback playback for \(type.debugLabel)")
    }
  }
}

extension ScanFeedbackCoordinator.FeedbackType {
  fileprivate var debugLabel: String {
    switch self {
    case .success:
      return "success"
    case .failure:
      return "failure"
    }
  }
}
