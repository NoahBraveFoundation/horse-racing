@preconcurrency import AVFoundation
import Dependencies
import Logging
import UIKit

struct BarcodeScanner {
  var startScanning: @Sendable (@escaping @Sendable (String) async -> Void) async -> Void
  var stopScanning: @Sendable () async -> Void
  var isAuthorized: @Sendable () async -> Bool
  var requestAuthorization: @Sendable () async -> Bool
  var waitUntilStopped: @Sendable () async -> Void
}

extension BarcodeScanner: DependencyKey {
  static let liveValue = BarcodeScanner(
    startScanning: { callback in
      await BarcodeScannerManager.shared.startScanning(callback: callback)
    },
    stopScanning: {
      await BarcodeScannerManager.shared.stopScanning()
    },
    isAuthorized: {
      await BarcodeScannerManager.shared.isAuthorized
    },
    requestAuthorization: {
      await BarcodeScannerManager.shared.requestAuthorization()
    },
    waitUntilStopped: {
      await BarcodeScannerManager.shared.waitUntilStopped()
    }
  )
}

extension DependencyValues {
  var barcodeScanner: BarcodeScanner {
    get { self[BarcodeScanner.self] }
    set { self[BarcodeScanner.self] = newValue }
  }
}

@MainActor
class BarcodeScannerManager: NSObject, ObservableObject {
  static let shared = BarcodeScannerManager()
  private let logger = Logger(label: "org.noahbrave.ticket-scanner.barcode")

  private(set) var captureSession: AVCaptureSession?
  private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  private var barcodeCallback: (@Sendable (String) async -> Void)?
  // Debounce / queue state
  private var isProcessingBarcode = false
  private var lastBarcode: String?
  private var lastBarcodeTimestamp: TimeInterval = 0
  private let minScanInterval: TimeInterval = 0.6  // ignore identical scans within this window
  // Future: queue distinct barcodes if we decide to process multiple sequentially
  private var pendingBarcodes: [String] = []

  @Published var isScanning = false
  @Published var isAuthorized = false

  private override init() {
    super.init()
    checkAuthorization()
  }

  func checkAuthorization() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      isAuthorized = true
    case .notDetermined:
      isAuthorized = false
    case .denied, .restricted:
      isAuthorized = false
    @unknown default:
      isAuthorized = false
    }
  }

  func requestAuthorization() async -> Bool {
    let status = await AVCaptureDevice.requestAccess(for: .video)
    isAuthorized = status
    logger.info("Camera authorization result: \(status ? "granted" : "denied")")
    return status
  }

  func startScanning(callback: @escaping @Sendable (String) async -> Void) async {
    guard isAuthorized else { return }

    barcodeCallback = callback
    logger.debug("Starting barcode scanning session")
    isScanning = true

    captureSession = AVCaptureSession()

    guard let captureSession = captureSession else { return }

    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
    let videoInput: AVCaptureDeviceInput

    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }

    if captureSession.canAddInput(videoInput) {
      captureSession.addInput(videoInput)
      logger.debug("Added video input to capture session")
    } else {
      logger.warning("Could not add video input to capture session")
      return
    }

    let metadataOutput = AVCaptureMetadataOutput()

    if captureSession.canAddOutput(metadataOutput) {
      captureSession.addOutput(metadataOutput)

      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      let types: [AVMetadataObject.ObjectType] = [
        .pdf417, .qr, .code128, .code39, .ean13, .ean8, .upce,
      ]
      metadataOutput.metadataObjectTypes = types
      logger.debug(
        "Configured metadata output types: \(types.map { $0.rawValue }.joined(separator: ", "))")
    } else {
      logger.warning("Could not add metadata output to capture session")
      return
    }

    // Start running on a background thread to avoid UI unresponsiveness
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      captureSession.startRunning()
      self?.logger.debug("Capture session started running")
    }
  }

  func stopScanning() async {
    isScanning = false
    captureSession?.stopRunning()
    captureSession = nil
    barcodeCallback = nil
    // Reset processing state so we can accept a new scan after stop
    isProcessingBarcode = false
    pendingBarcodes.removeAll()
    logger.debug("Stopped barcode scanning session")
  }

  func waitUntilStopped() async {
    // Polling loop; exits when scanning flag is false or task cancelled.
    while isScanning && !Task.isCancelled {
      try? await Task.sleep(for: .milliseconds(150))
    }
  }
}

extension BarcodeScannerManager: @MainActor AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(
    _ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection
  ) {
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
        return
      }
      guard let stringValue = readableObject.stringValue else { return }

      // Only process barcodes that start with "NBT:"
      if stringValue.hasPrefix("NBT:") {
        let now = Date().timeIntervalSince1970

        // If we're already processing a barcode, optionally queue distinct new ones
        if isProcessingBarcode {
          if stringValue != lastBarcode && !pendingBarcodes.contains(stringValue) {
            pendingBarcodes.append(stringValue)
            logger.debug("Queued distinct barcode while processing: \(stringValue)")
          } else {
            logger.debug("Ignored barcode while processing active one: \(stringValue)")
          }
          return
        }

        // Debounce identical barcode within min interval
        if stringValue == lastBarcode && (now - lastBarcodeTimestamp) < minScanInterval {
          logger.debug("Debounced duplicate barcode within interval: \(stringValue)")
          return
        }

        // Mark processing & record last
        isProcessingBarcode = true
        lastBarcode = stringValue
        lastBarcodeTimestamp = now

        // Immediately stop capture to reduce duplicate delegate calls
        captureSession?.stopRunning()

        Task { [barcodeCallback, logger] in
          logger.info("Barcode scanned: \(stringValue)")
          await barcodeCallback?(stringValue)
          // Process any queued distinct barcodes (optional simple strategy)
          while let next = pendingBarcodes.first {
            pendingBarcodes.removeFirst()
            lastBarcode = next
            lastBarcodeTimestamp = Date().timeIntervalSince1970
            logger.info("Processing queued barcode: \(next)")
            await barcodeCallback?(next)
          }
          await stopScanning()
        }
      }
    }
  }
}
