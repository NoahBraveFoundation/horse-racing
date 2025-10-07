import AVFoundation
import Dependencies
import UIKit

@DependencyClient
struct BarcodeScanner {
    var startScanning: @Sendable (@Sendable (String) -> Void) async -> Void
    var stopScanning: @Sendable () async -> Void
    var isAuthorized: @Sendable () async -> Bool
    var requestAuthorization: @Sendable () async -> Bool
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
        }
    )
}

@MainActor
class BarcodeScannerManager: NSObject, ObservableObject {
    static let shared = BarcodeScannerManager()
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var barcodeCallback: (@Sendable (String) -> Void)?
    
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
        return status
    }
    
    func startScanning(callback: @escaping @Sendable (String) -> Void) async {
        guard isAuthorized else { return }
        
        barcodeCallback = callback
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
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.pdf417, .qr, .code128, .code39, .ean13, .ean8, .upce]
        } else {
            return
        }
        
        captureSession.startRunning()
    }
    
    func stopScanning() async {
        isScanning = false
        captureSession?.stopRunning()
        captureSession = nil
        barcodeCallback = nil
    }
}

extension BarcodeScannerManager: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Only process barcodes that start with "NBT:"
            if stringValue.hasPrefix("NBT:") {
                barcodeCallback?(stringValue)
                Task {
                    await stopScanning()
                }
            }
        }
    }
}

