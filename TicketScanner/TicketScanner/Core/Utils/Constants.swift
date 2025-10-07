import Foundation

struct Constants {
    struct API {
        static let baseURL = "https://horses.noahbrave.org/graphql"
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

