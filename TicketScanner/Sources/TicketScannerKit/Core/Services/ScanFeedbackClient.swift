import AudioToolbox
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

  private var successSound: SystemSoundID = 0
  private var failureSound: SystemSoundID = 0
  @SharedReader(.appStorage(SharedStorageKey.hapticsEnabled))
  private var hapticsEnabled: Bool = true
  @SharedReader(.appStorage(SharedStorageKey.audioFeedbackEnabled))
  private var audioFeedbackEnabled: Bool = true

  private init() {
    successSound = loadSound(named: "success")
    failureSound = loadSound(named: "failure")
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
      playSound(id: successSound)
    case .failure:
      playSound(id: failureSound)
    }
  }

  private func loadSound(named: String) -> SystemSoundID {
    guard let url = Bundle.main.url(forResource: named, withExtension: "wav") else {
      logger.warning("Missing scan feedback sound resource: \(named).wav")
      return 0
    }

    var soundID: SystemSoundID = 0
    let status = AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
    guard status == kAudioServicesNoError else {
      logger.error("Failed to create system sound for \(named).wav with status \(status)")
      return 0
    }
    logger.debug("Loaded scan feedback sound \(named).wav with id \(soundID)")
    return soundID
  }

  private func playSound(id: SystemSoundID) {
    guard id != 0 else {
      logger.error("Attempted to play scan feedback before sound was loaded")
      return
    }
    logger.debug("Triggering scan feedback sound id \(id)")
    AudioServicesPlaySystemSound(id)
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
