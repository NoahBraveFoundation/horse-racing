import SwiftUI
import ComposableArchitecture
import AVFoundation

struct ScanningView: View {
    let store: StoreOf<ScanningFeature>
    @State private var showingStats = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Scanner Status
                HStack {
                    Circle()
                        .fill(store.isScanning ? .green : .red)
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
                
                // Stats Summary
                if let stats = store.scanningStats {
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(stats.totalScanned)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Scanned")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(stats.totalTickets)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Total")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(Int(Double(stats.totalScanned) / Double(stats.totalTickets) * 100))%")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Complete")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                Spacer()
                
                // Stats Button
                Button("View Detailed Stats") {
                    showingStats = true
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("Ticket Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        // This would be handled by the parent view
                    }
                }
            }
            .sheet(isPresented: $showingStats) {
                StatsView(store: store)
            }
            .sheet(isPresented: $store.isShowingResult.sending(\.dismissResult)) {
                if let result = store.lastScanResult {
                    ScanResultView(result: result) {
                        store.send(.dismissResult)
                    }
                }
            }
            .alert("Error", isPresented: .constant(store.errorMessage != nil)) {
                Button("OK") {
                    store.send(.clearError)
                }
            } message: {
                Text(store.errorMessage ?? "")
            }
            .onAppear {
                store.send(.loadStats)
                store.send(.loadRecentScans)
            }
        }
    }
}

struct BarcodeScannerView: UIViewRepresentable {
    let isScanning: Bool
    let onBarcodeScanned: (String) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.text = "Camera Preview"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // In a real implementation, this would update the camera preview
        // For now, we'll just show a placeholder
    }
}

#Preview {
    ScanningView(
        store: Store(initialState: ScanningFeature.State()) {
            ScanningFeature()
        }
    )
}
