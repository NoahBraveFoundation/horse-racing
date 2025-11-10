import Foundation
import AVFoundation

struct Constants {
    struct API {
        static let baseURL = "https://api.horses.noahbrave.org"
//        static let baseURL = "http://192.168.1.156:8080"
        static let timeout: TimeInterval = 30
    }
    
    struct Barcode {
        static let prefix = "NBT:"
        static let supportedFormats: [AVMetadataObject.ObjectType] = [
            .pdf417, .qr, .code128, .code39, .ean13, .ean8, .upce
        ]
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let animationDuration: Double = 0.3
    }
}

