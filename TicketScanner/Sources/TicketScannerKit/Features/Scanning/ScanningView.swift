import AVFoundation
import ComposableArchitecture
import SwiftUI

public struct ScanningView: View {
  @Bindable var store: StoreOf<ScanningFeature>

  public init(store: StoreOf<ScanningFeature>) {
    self.store = store
  }

  public var body: some View {
    contentView
      .navigationTitle("Ticket Scanner")
      .navigationBarTitleDisplayMode(.inline)
      .sheet(
        store: store.scope(state: \.$result, action: \.result)
      ) { store in
        ScanResultView(store: store)
      }
      .alert("Error", isPresented: .constant(store.errorMessage != nil)) {
        Button("OK") {
          store.send(.clearError)
        }
      } message: {
        Text(store.errorMessage ?? "")
      }
      .onAppear {
        store.send(.checkCameraPermissions)
      }
  }

  private var contentView: some View {
    VStack(spacing: 20) {
      // Scanner Status
      HStack {
        Circle()
          .fill(store.isScanning ? Color.brandGreen : .red)
          .frame(width: 12, height: 12)
        Text(store.isScanning ? "Scanning..." : "Ready to Scan")
          .font(.headline)
      }
      .padding()

      // Camera Preview
      BarcodeScannerView(
        isScanning: store.isScanning,
        onBarcodeScanned: { barcode in
          store.send(.barcodeScanned(barcode))
        }
      )
      .frame(maxHeight: 300)
      .cornerRadius(12)
      .padding()

      // Scan Button
      Button(store.isScanning ? "Stop Scanning" : "Start Scanning") {
        if store.isScanning {
          store.send(.stopScanning)
        } else {
          store.send(.startScanning)
        }
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      Spacer()
    }
    .overlay(alignment: .bottom) {
      if store.horseAudio.isToastVisible {
        HorseAudioToastView(
          message: store.horseAudio.toastMessage ?? "Playing horse audio",
          isPlaying: store.horseAudio.isAudioPlaying,
          canReplay: store.horseAudio.canReplay,
          onReplay: { store.send(.replayHorseAudio) }
        )
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(), value: store.horseAudio.isToastVisible)
      }
    }
  }
}

private struct HorseAudioToastView: View {
  let message: String
  let isPlaying: Bool
  let canReplay: Bool
  let onReplay: () -> Void

  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 4) {
        Label("VIP Horse Intro", systemImage: "music.note.list")
          .font(.caption2)
          .foregroundColor(.secondary)
        Text(message)
          .font(.headline)
        Text(statusText)
          .font(.caption)
          .foregroundColor(.secondary)
      }

      Spacer()

      if isPlaying {
        ProgressView()
          .progressViewStyle(.circular)
      } else if canReplay {
        Button("Replay") {
          onReplay()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
      }
    }
    .padding()
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
  }

  private var statusText: String {
    if isPlaying {
      return "Playing now..."
    } else if canReplay {
      return "Replay available"
    } else {
      return "Preparing audio..."
    }
  }
}

struct BarcodeScannerView: UIViewRepresentable {
  let isScanning: Bool
  let onBarcodeScanned: (String) -> Void

  func makeUIView(context: Context) -> ScannerContainerView {
    let view = ScannerContainerView()
    context.coordinator.containerView = view
    return view
  }

  func updateUIView(_ uiView: ScannerContainerView, context: Context) {
    context.coordinator.containerView = uiView
    context.coordinator.updateScanningState(isScanning)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(onBarcodeScanned: onBarcodeScanned)
  }

  @MainActor
  final class Coordinator: NSObject {
    let onBarcodeScanned: (String) -> Void
    weak var containerView: ScannerContainerView?
    private var previewTask: Task<Void, Never>?
    private weak var attachedSession: AVCaptureSession?

    init(onBarcodeScanned: @escaping (String) -> Void) {
      self.onBarcodeScanned = onBarcodeScanned
    }

    deinit {
      previewTask?.cancel()
    }

    func updateScanningState(_ isScanning: Bool) {
      previewTask?.cancel()
      previewTask = nil

      guard containerView != nil else { return }

      if isScanning {
        previewTask = Task { @MainActor [weak self] in
          await self?.preparePreview()
        }
      } else {
        teardownPreview()
      }
    }

    private func preparePreview() async {
      let manager = BarcodeScannerManager.shared

      for _ in 0..<20 {
        if Task.isCancelled { return }
        guard let view = containerView else { return }

        if let captureSession = manager.captureSession {
          if attachedSession !== captureSession {
            attachPreview(with: captureSession)
            attachedSession = captureSession
          }
          view.setPlaceholderVisible(false)
          return
        }

        try? await Task.sleep(for: .milliseconds(50))
      }

      containerView?.setPlaceholderVisible(true)
    }

    private func attachPreview(with captureSession: AVCaptureSession) {
      guard let view = containerView else { return }
      let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      previewLayer.videoGravity = .resizeAspectFill
      view.previewLayer = previewLayer
      view.configureOverlay(addScanningOverlay)
    }

    private func teardownPreview() {
      attachedSession = nil
      guard let view = containerView else { return }
      view.previewLayer = nil
      view.removeOverlay()
      view.setPlaceholderVisible(true)
    }

    private func addScanningOverlay(to view: UIView) {
      view.subviews.forEach { $0.removeFromSuperview() }

      let overlayView = UIView(frame: view.bounds)
      overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
      overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      let cutoutSize = CGSize(width: 250, height: 150)
      let cutoutRect = CGRect(
        x: (view.bounds.width - cutoutSize.width) / 2,
        y: (view.bounds.height - cutoutSize.height) / 2,
        width: cutoutSize.width,
        height: cutoutSize.height
      )

      let path = UIBezierPath(rect: overlayView.bounds)
      let cutoutPath = UIBezierPath(roundedRect: cutoutRect, cornerRadius: 12)
      path.append(cutoutPath)
      path.usesEvenOddFillRule = true

      let maskLayer = CAShapeLayer()
      maskLayer.path = path.cgPath
      maskLayer.fillRule = .evenOdd
      overlayView.layer.mask = maskLayer

      view.addSubview(overlayView)

      let cornerLength: CGFloat = 20
      let cornerWidth: CGFloat = 3
      let corners: [(CGPoint, CGPoint, CGPoint)] = [
        (
          CGPoint(x: cutoutRect.minX, y: cutoutRect.minY),
          CGPoint(x: cutoutRect.minX + cornerLength, y: cutoutRect.minY),
          CGPoint(x: cutoutRect.minX, y: cutoutRect.minY + cornerLength)
        ),
        (
          CGPoint(x: cutoutRect.maxX, y: cutoutRect.minY),
          CGPoint(x: cutoutRect.maxX - cornerLength, y: cutoutRect.minY),
          CGPoint(x: cutoutRect.maxX, y: cutoutRect.minY + cornerLength)
        ),
        (
          CGPoint(x: cutoutRect.minX, y: cutoutRect.maxY),
          CGPoint(x: cutoutRect.minX + cornerLength, y: cutoutRect.maxY),
          CGPoint(x: cutoutRect.minX, y: cutoutRect.maxY - cornerLength)
        ),
        (
          CGPoint(x: cutoutRect.maxX, y: cutoutRect.maxY),
          CGPoint(x: cutoutRect.maxX - cornerLength, y: cutoutRect.maxY),
          CGPoint(x: cutoutRect.maxX, y: cutoutRect.maxY - cornerLength)
        ),
      ]

      for (corner, horizontal, vertical) in corners {
        let path = UIBezierPath()
        path.move(to: horizontal)
        path.addLine(to: corner)
        path.addLine(to: vertical)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.lineWidth = cornerWidth
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor

        overlayView.layer.addSublayer(shapeLayer)
      }

      let instructionLabel = UILabel()
      instructionLabel.text = "Align barcode within frame"
      instructionLabel.textColor = .white
      instructionLabel.font = .systemFont(ofSize: 14, weight: .medium)
      instructionLabel.textAlignment = .center
      instructionLabel.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(instructionLabel)

      NSLayoutConstraint.activate([
        instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        instructionLabel.topAnchor.constraint(
          equalTo: view.topAnchor, constant: cutoutRect.minY - 30),
      ])
    }
  }
}

extension BarcodeScannerView {
  final class ScannerContainerView: UIView {
    let previewContainer = UIView()
    let overlayContainer = UIView()
    private let placeholderView = PlaceholderView()

    var previewLayer: AVCaptureVideoPreviewLayer? {
      didSet {
        oldValue?.removeFromSuperlayer()
        if let previewLayer {
          previewLayer.frame = previewContainer.bounds
          previewLayer.needsDisplayOnBoundsChange = true
          previewContainer.layer.addSublayer(previewLayer)
        }
      }
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .black
      clipsToBounds = true

      previewContainer.translatesAutoresizingMaskIntoConstraints = false
      overlayContainer.translatesAutoresizingMaskIntoConstraints = false
      overlayContainer.isUserInteractionEnabled = false
      overlayContainer.isHidden = true
      placeholderView.translatesAutoresizingMaskIntoConstraints = false

      addSubview(previewContainer)
      addSubview(overlayContainer)
      addSubview(placeholderView)

      NSLayoutConstraint.activate([
        previewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
        previewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        previewContainer.topAnchor.constraint(equalTo: topAnchor),
        previewContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

        overlayContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
        overlayContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        overlayContainer.topAnchor.constraint(equalTo: topAnchor),
        overlayContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

        placeholderView.centerXAnchor.constraint(equalTo: centerXAnchor),
        placeholderView.centerYAnchor.constraint(equalTo: centerYAnchor),
        placeholderView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
      ])
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      previewLayer?.frame = previewContainer.bounds
    }

    func setPlaceholderVisible(_ isVisible: Bool) {
      placeholderView.isHidden = !isVisible
      overlayContainer.isHidden = isVisible
    }

    func configureOverlay(_ builder: (UIView) -> Void) {
      builder(overlayContainer)
      overlayContainer.isHidden = false
    }

    func removeOverlay() {
      overlayContainer.subviews.forEach { $0.removeFromSuperview() }
    }
  }

  final class PlaceholderView: UIView {
    override init(frame: CGRect) {
      super.init(frame: frame)
      translatesAutoresizingMaskIntoConstraints = false
      backgroundColor = .secondarySystemBackground
      layer.cornerRadius = 12
      layer.masksToBounds = true
      layer.borderWidth = 1
      layer.borderColor = UIColor.systemGray4.cgColor
      layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

      let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 42, weight: .medium)
      let imageView = UIImageView(
        image: UIImage(systemName: "barcode.viewfinder", withConfiguration: symbolConfiguration))
      imageView.tintColor = .systemGray
      imageView.contentMode = .scaleAspectFit

      let titleLabel = UILabel()
      titleLabel.text = "Camera preview will appear once scanning starts"
      titleLabel.textColor = .secondaryLabel
      titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
      titleLabel.textAlignment = .center
      titleLabel.numberOfLines = 0

      let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
      stackView.axis = .vertical
      stackView.alignment = .center
      stackView.spacing = 12
      stackView.translatesAutoresizingMaskIntoConstraints = false

      addSubview(stackView)

      NSLayoutConstraint.activate([
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
      ])
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

#Preview {
  ScanningView(
    store: Store(initialState: ScanningFeature.State()) {
      ScanningFeature()
    }
  )
}
