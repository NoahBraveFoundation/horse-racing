import ComposableArchitecture
import Dependencies
import Foundation
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
    public var scanningStats: ScanningStats?
    public var recentScans: [TicketScan] = []
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
    case loadStats
    case statsResponse(TaskResult<ScanningStats>)
    case loadRecentScans
    case recentScansResponse(TaskResult<[TicketScan]>)
    case checkCameraPermissions
    case cameraPermissionDenied
    case requestHorseAudio(UUID)
    case requestHorseAudioResponse(TaskResult<HorseAudioClip>)
    case playHorseAudio
    case replayHorseAudio
    case audioPlaybackFinished
    case hideAudioToast
    case horseAudioPlaybackFailed(String)
  }

  @Dependency(\.barcodeScanner) var barcodeScanner
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.locationService) var locationService
  @Dependency(\.audioPlaybackClient) var audioPlaybackClient

  public init() {}

  public var body: some ReducerOf<Self> {
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

        // Reload stats and recent scans after successful scan
        return .concatenate(
          .run { _ in
            @Dependency(\.barcodeScanner) var barcodeScanner
            await barcodeScanner.stopScanning()
          },
          .send(.loadStats),
          .send(.loadRecentScans),
          response.ticket.map { .send(.requestHorseAudio($0.id)) } ?? .none
        )

      case .scanTicketResponse(.failure(let error)):
        state.errorMessage = error.localizedDescription
        return .run { _ in
          @Dependency(\.barcodeScanner) var barcodeScanner
          await barcodeScanner.stopScanning()
        }

      case .dismissResult:
        state.isShowingResult = false
        state.lastScanResult = nil
        return .none

      case .clearError:
        state.errorMessage = nil
        return .none

      case .setCurrentScanner(let scanner):
        state.currentScanner = scanner
        return .none

      case .loadStats:
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .statsResponse(
              await TaskResult {
                try await apiClient.getScanningStats()
              }
            ))
        }

      case .statsResponse(.success(let stats)):
        state.scanningStats = stats
        return .none

      case .statsResponse(.failure(let error)):
        state.errorMessage = error.localizedDescription
        return .none

      case .loadRecentScans:
        return .run { send in
          @Dependency(\.apiClient) var apiClient
          await send(
            .recentScansResponse(
              await TaskResult {
                try await apiClient.getRecentScans(10)
              }
            ))
        }

      case .recentScansResponse(.success(let scans)):
        state.recentScans = scans
        return .none

      case .recentScansResponse(.failure(let error)):
        state.errorMessage = error.localizedDescription
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
          .cancel(id: HorseAudioToastTimerID.toast),
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
        return .run { send in
          @Dependency(\.continuousClock) var clock
          try await clock.sleep(for: .seconds(15))
          await send(.hideAudioToast)
        }
        .cancellable(id: HorseAudioToastTimerID.toast, cancelInFlight: true)

      case .hideAudioToast:
        state.horseAudio.isToastVisible = false
        state.horseAudio.canReplay = false
        return .none

      case .horseAudioPlaybackFailed(let message):
        state.horseAudio.isAudioPlaying = false
        state.errorMessage = message
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

private enum HorseAudioToastTimerID: Hashable {
  case toast
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
