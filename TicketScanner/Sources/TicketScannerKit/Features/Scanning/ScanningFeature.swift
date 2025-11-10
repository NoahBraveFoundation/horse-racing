import ComposableArchitecture
import Dependencies
import Foundation
import Sharing
import UIKit

@Reducer
public struct ScanningFeature {
  @ObservableState
  public struct State: Equatable {
    public var isScanning = false
    public var lastScanResult: ScanResult?
    public var errorMessage: String?
    public var isShowingResult = false
    public var currentScanner: User?
    public var stats = StatsFeature.State()
    @Shared(.appStorage(SharedStorageKey.tickets))
    var cachedTickets: [TicketDirectoryEntry] = []
    public var horseAudio = HorseAudioState()

    public init() {}
  }

  public enum Action: Equatable {
    case startScanning
    case stopScanning
    case barcodeScanned(String)
    case scanTicketResponse(TaskResult<ScanTicketResponse>)
    case dismissResult
    case clearError
    case setCurrentScanner(User)
    case stats(StatsFeature.Action)
    case loadAllTickets
    case allTicketsResponse(TaskResult<[TicketDirectoryEntry]>)
    case checkCameraPermissions
    case cameraPermissionDenied
    case requestHorseAudio(UUID)
    case requestHorseAudioResponse(TaskResult<HorseAudioClip>)
    case playHorseAudio
    case replayHorseAudio
    case audioPlaybackFinished
    case horseAudioPlaybackFailed(String)
  }

  @Dependency(\.barcodeScanner) var barcodeScanner
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.locationService) var locationService
  @Dependency(\.audioPlaybackClient) var audioPlaybackClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(state: \.stats, action: \.stats) {
      StatsFeature()
    }
    Reduce { state, action in
      switch action {
      case .checkCameraPermissions:
        return .run { send in
          @Dependency(\.barcodeScanner) var barcodeScanner
          let isAuthorized = await barcodeScanner.isAuthorized()
          if !isAuthorized {
            let granted = await barcodeScanner.requestAuthorization()
            if !granted {
              await send(.cameraPermissionDenied)
            }
          }
        }

      case .cameraPermissionDenied:
        state.errorMessage =
          "Camera access is required to scan tickets. Please enable camera access in Settings."
        return .none

      case .startScanning:
        state.isScanning = true
        state.errorMessage = nil
        return .run { send in
          @Dependency(\.barcodeScanner) var barcodeScanner

          // Check authorization first
          let isAuthorized = await barcodeScanner.isAuthorized()
          if !isAuthorized {
            let granted = await barcodeScanner.requestAuthorization()
            if !granted {
              await send(.cameraPermissionDenied)
              await send(.stopScanning)
              return
            }
          }

          await barcodeScanner.startScanning { barcode in
            await send(.barcodeScanned(barcode))
          }
          // Keep effect alive until scanning stops to avoid completed-effect warning
          await barcodeScanner.waitUntilStopped()
        }

      case .stopScanning:
        state.isScanning = false
        return .run { _ in
          @Dependency(\.barcodeScanner) var barcodeScanner
          await barcodeScanner.stopScanning()
        }

      case .barcodeScanned(let barcode):
        state.isScanning = false
        return .run { send in
          @Dependency(\.locationService) var locationService
          @Dependency(\.apiClient) var apiClient
          let location = await locationService.currentLocation()
          let deviceInfo = await getDeviceInfo()

          await send(
            .scanTicketResponse(
              await TaskResult {
                try await apiClient.scanTicket(barcode, location, deviceInfo)
              }
            ))
        }

      case .scanTicketResponse(.success(let response)):
        state.lastScanResult = ScanResult(
          success: response.success,
          message: response.message,
          ticket: response.ticket,
          alreadyScanned: response.alreadyScanned,
          previousScan: response.previousScan
        )
        state.isShowingResult = true

        let isSuccessful = response.success
        let feedbackEffect: Effect<Action> = .run { _ in
          @Dependency(\.scanFeedbackClient) var scanFeedbackClient
          if isSuccessful {
            await scanFeedbackClient.playSuccess()
          } else {
            await scanFeedbackClient.playFailure()
          }
        }

        // Reload stats and recent scans after successful scan
        let reloadEffects: Effect<Action> = .concatenate(
          .run { _ in
            @Dependency(\.barcodeScanner) var barcodeScanner
            await barcodeScanner.stopScanning()
          },
          .send(.stats(.refresh(.scanUpdate))),
          .send(.loadAllTickets),
          response.ticket.map { .send(.requestHorseAudio($0.id)) } ?? .none
        )

        return .merge(feedbackEffect, reloadEffects)

      case .scanTicketResponse(.failure(let error)):
        state.errorMessage = nil
        state.lastScanResult = ScanResult(
          success: false,
          message: error.localizedDescription,
          ticket: nil,
          alreadyScanned: false,
          previousScan: nil
        )
        state.isShowingResult = true
        let feedbackEffect: Effect<Action> = .run { _ in
          @Dependency(\.scanFeedbackClient) var scanFeedbackClient
          await scanFeedbackClient.playFailure()
        }
        let stopEffect: Effect<Action> = .run { _ in
          @Dependency(\.barcodeScanner) var barcodeScanner
          await barcodeScanner.stopScanning()
        }
        return .merge(feedbackEffect, stopEffect)

      case .dismissResult:
        state.isShowingResult = false
        state.lastScanResult = nil
        state.errorMessage = nil
        return .none

      case .clearError:
        state.errorMessage = nil
        return .none

      case .setCurrentScanner(let scanner):
        state.currentScanner = scanner
        return .none

      case .stats:
        return .none

      case .requestHorseAudio(let ticketId):
        state.horseAudio = HorseAudioState()
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .requestHorseAudioResponse(
              await TaskResult {
                try await apiClient.requestHorseAudio(ticketId)
              }
            ))
        }

      case .requestHorseAudioResponse(.success(let clip)):
        guard let data = clip.decodedAudioData else {
          state.errorMessage = "Unable to decode horse audio clip."
          return .none
        }
        state.horseAudio.clip = clip
        state.horseAudio.audioData = data
        state.horseAudio.toastMessage = clip.title
        state.horseAudio.isToastVisible = true
        state.horseAudio.canReplay = false
        return .send(.playHorseAudio)

      case .requestHorseAudioResponse(.failure(let error)):
        state.horseAudio.isToastVisible = false
        state.errorMessage = error.localizedDescription
        return .none

      case .playHorseAudio:
        guard let data = state.horseAudio.audioData else { return .none }
        state.horseAudio.isToastVisible = true
        state.horseAudio.isAudioPlaying = true
        state.horseAudio.canReplay = false
        return .concatenate(
          .cancel(id: HorseAudioPlaybackID.playback),
          .run { send in
            @Dependency(\.audioPlaybackClient) var audioPlaybackClient
            do {
              try await audioPlaybackClient.play(data)
              await send(.audioPlaybackFinished)
            } catch {
              await send(.horseAudioPlaybackFailed(error.localizedDescription))
            }
          }
          .cancellable(id: HorseAudioPlaybackID.playback, cancelInFlight: true)
        )

      case .replayHorseAudio:
        guard state.horseAudio.audioData != nil else { return .none }
        return .concatenate(
          .run { _ in
            @Dependency(\.audioPlaybackClient) var audioPlaybackClient
            await audioPlaybackClient.stop()
          },
          .send(.playHorseAudio)
        )

      case .audioPlaybackFinished:
        state.horseAudio.isAudioPlaying = false
        state.horseAudio.canReplay = true
        return .none

      case .horseAudioPlaybackFailed(let message):
        state.horseAudio.isAudioPlaying = false
        state.errorMessage = message
        return .none

      case .loadAllTickets:
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .allTicketsResponse(
              await TaskResult {
                try await apiClient.getAllTickets()
              }
            ))
        }

      case .allTicketsResponse(.success(let tickets)):
        state.$cachedTickets.withLock { $0 = tickets }
        return .none

      case .allTicketsResponse(.failure(let error)):
        state.errorMessage = error.localizedDescription
        return .none
      }
    }
  }
}

@MainActor
private func getDeviceInfo() async -> String {
  let device = UIDevice.current
  return "\(device.model) - \(device.systemName) \(device.systemVersion)"
}

private enum HorseAudioPlaybackID: Hashable {
  case playback
}

extension ScanningFeature {
  public struct HorseAudioState: Equatable {
    var clip: HorseAudioClip?
    var audioData: Data?
    var isToastVisible = false
    var isAudioPlaying = false
    var canReplay = false
    var toastMessage: String?
  }
}
