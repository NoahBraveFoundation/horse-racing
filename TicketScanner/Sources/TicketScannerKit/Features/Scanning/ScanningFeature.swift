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
    public var errorMessage: String?
    public var currentScanner: User?
    public var stats = StatsFeature.State()
    @Presents public var result: ScanResultFeature.State?
    @Shared(.appStorage(SharedStorageKey.tickets))
    var cachedTickets: [TicketDirectoryEntry] = []
    public var horseAudio = HorseAudioState()
    public var requestedOrderNumbers: Set<String> = []

    public init() {}
  }

  public enum Action: Equatable {
    case startScanning
    case stopScanning
    case barcodeScanned(String)
    case scanTicketResponse(TaskResult<ScanTicketResponse>)
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
    case result(PresentationAction<ScanResultFeature.Action>)
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
    .ifLet(\.$result, action: \.result) {
      ScanResultFeature()
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
          let deviceInfo = await DeviceInfoProvider.currentDescription()

          await send(
            .scanTicketResponse(
              await TaskResult {
                try await apiClient.scanTicket(barcode, location, deviceInfo)
              }
            ))
        }

      case .scanTicketResponse(.success(let response)):
        state.result = ScanResultFeature.State(
          result: ScanResult(
            success: response.success,
            message: response.message,
            ticket: response.ticket,
            alreadyScanned: response.alreadyScanned,
            previousScan: response.previousScan
          ))

        let isSuccessful = response.success
        let feedbackEffect: Effect<Action> = .run { _ in
          @Dependency(\.scanFeedbackClient) var scanFeedbackClient
          if isSuccessful {
            await scanFeedbackClient.playSuccess()
          } else {
            await scanFeedbackClient.playFailure()
          }
        }

        // Check if we should request horse audio for this order
        let shouldRequestAudio: Bool
        if let ticket = response.ticket,
          let entry = state.cachedTickets.first(where: { $0.id == ticket.id }),
          let orderNumber = entry.orderNumber
        {
          shouldRequestAudio = !state.requestedOrderNumbers.contains(orderNumber)
          if shouldRequestAudio {
            state.requestedOrderNumbers.insert(orderNumber)
          }
        } else {
          shouldRequestAudio = response.ticket != nil
        }

        // Reload stats and recent scans after successful scan
        let reloadEffects: Effect<Action> = .concatenate(
          .run { _ in
            @Dependency(\.barcodeScanner) var barcodeScanner
            await barcodeScanner.stopScanning()
          },
          .send(.stats(.refresh(.scanUpdate))),
          .send(.loadAllTickets),
          shouldRequestAudio && response.ticket != nil
            ? .send(.requestHorseAudio(response.ticket!.id))
            : .none
        )

        return .merge(feedbackEffect, reloadEffects)

      case .scanTicketResponse(.failure(let error)):
        state.errorMessage = nil
        state.result = ScanResultFeature.State(
          result: ScanResult(
            success: false,
            message: error.localizedDescription,
            ticket: nil,
            alreadyScanned: false,
            previousScan: nil
          ))
        let feedbackEffect: Effect<Action> = .run { _ in
          @Dependency(\.scanFeedbackClient) var scanFeedbackClient
          await scanFeedbackClient.playFailure()
        }
        let stopEffect: Effect<Action> = .run { _ in
          @Dependency(\.barcodeScanner) var barcodeScanner
          await barcodeScanner.stopScanning()
        }
        return .merge(feedbackEffect, stopEffect)

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

      case .result(.presented(.doneButtonTapped)):
        state.result = nil
        return .none

      case .result(.dismiss):
        state.result = nil
        return .none

      case .result:
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
