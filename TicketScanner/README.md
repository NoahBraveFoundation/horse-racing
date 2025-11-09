# Ticket Scanner

A modern iOS app built with SwiftUI and The Composable Architecture (TCA) for scanning tickets at the NoahBRAVE Foundation horse racing fundraiser event.

## Project Structure

This project is organized as:
- **Swift Package** (`Package.swift`): Library containing core business logic (TicketScannerKit)
- **iOS App** (`TicketScannerApp/`): Xcode project for the user-facing application

```
TicketScanner/
├── Package.swift                      # Swift Package for library code
├── Sources/
│   └── TicketScannerKit/             # Core library module
│       ├── Core/                      # Core functionality
│       │   ├── Models/               # Data models
│       │   ├── Services/             # API client, Apollo, scanning services
│       │   └── Utils/                # Utilities and extensions
│       └── Features/                  # TCA Features
│           ├── Authentication/        # Login flow
│           ├── Scanning/             # Ticket scanning
│           ├── Settings/             # App settings
│           └── Stats/                # Statistics dashboard
├── GraphQL/
│   └── Operations/                    # GraphQL query/mutation files
├── TicketScannerApp/                 # iOS Application
│   ├── project.yml                   # XcodeGen project definition
│   ├── TicketScannerApp.xcodeproj/  # Generated Xcode project
│   └── TicketScannerApp/            # App target
│       ├── TicketScannerApp.swift   # App entry point
│       ├── Assets.xcassets/         # Images and resources
│       └── Resources/               # Info.plist, etc.
└── apollo-codegen-config.json        # Apollo code generation config
```

## Features

- **Admin Authentication**: Secure login for admin users
- **Barcode Scanning**: Real-time ticket scanning with camera integration
- **Duplicate Prevention**: Prevents scanning the same ticket multiple times
- **Location Tracking**: Records where tickets are scanned
- **Statistics Dashboard**: Real-time scanning statistics and analytics
- **Offline Support**: Handles network failures gracefully

## Architecture

### TicketScannerKit (Swift Package)
- **TCA Features**: Modular features using The Composable Architecture 1.0+
- **Apollo GraphQL**: Type-safe GraphQL client with code generation
- **Core Services**: API client, barcode scanning, location services
- **Models**: Data models shared across features

### iOS App
- **SwiftUI**: Modern, declarative UI framework
- **Dependencies**: Depends on TicketScannerKit package
- **Resources**: Assets, Info.plist, and app-specific configuration

## Installation

### Prerequisites
- Xcode 15.0+
- Swift 6.0+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (for project generation)

### iOS App Setup
1. **Open the Xcode project:**
   ```bash
   cd TicketScannerApp
   open TicketScannerApp.xcodeproj
   ```

2. **Set your development team** in Xcode project settings

3. **Build and run** (⌘R)

### Regenerating the Xcode Project
If you modify `TicketScannerApp/project.yml`:
```bash
cd TicketScannerApp
xcodegen generate
```

## Installation

### Prerequisites
- Xcode 15.0+
- Swift 6.0+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (for project generation)

### iOS App Setup
1. **Open the Xcode project:**
   ```bash
   cd TicketScannerApp
   open TicketScannerApp.xcodeproj
   ```

2. **Set your development team** in Xcode project settings

3. **Build and run** (⌘R)

### Regenerating the Xcode Project
If you modify `TicketScannerApp/project.yml`:
```bash
cd TicketScannerApp
xcodegen generate
```

## Development

### Working with the Swift Package
The `TicketScannerKit` package contains all business logic and can be developed independently:
```bash
# Build the package
swift build

# Run tests
swift test

# Open in Xcode
open Package.swift
```

## Usage

### Admin Login
1. Open the app
2. Enter admin email and password
3. Tap "Login"

### Scanning Tickets
1. Tap "Start Scanning" to activate camera
2. Point camera at ticket barcode
3. App will automatically process the scan
4. View scan result and ticket details

### Viewing Statistics
1. Tap "View Detailed Stats" from main screen
2. See real-time scanning statistics
3. View recent scans and hourly breakdown

## Security

- **Admin-only Access**: Only authenticated admin users can scan tickets
- **Barcode Validation**: Validates barcode format before processing
- **Duplicate Prevention**: Prevents scanning the same ticket twice
- **Audit Trail**: Complete record of all scanning activities

## Permissions

The app requires the following permissions:
- **Camera**: To scan ticket barcodes
- **Location**: To record where tickets are scanned (optional)

## API Endpoints

### GraphQL Endpoint
- **URL**: `https://horses.noahbrave.org/graphql`
- **Method**: POST
- **Content-Type**: application/json

### Key Mutations
```graphql
mutation ScanTicket($ticketId: UUID!, $scanLocation: String, $deviceInfo: String) {
  scanTicket(ticketId: $ticketId, scanLocation: $scanLocation, deviceInfo: $deviceInfo) {
    success
    message
    ticket {
      id
      attendeeFirst
      attendeeLast
      seatAssignment
      state
    }
    alreadyScanned
    previousScan {
      scanTimestamp
      scanner {
        firstName
        lastName
      }
    }
  }
}
```

## Development

### Adding New Features
1. Create new TCA features in `Sources/TicketScannerKit/Features/`
2. Add corresponding GraphQL operations in `GraphQL/Operations/`
3. Update the app UI in `TicketScannerApp/TicketScannerApp/`
4. Regenerate Apollo code as needed

### GraphQL Code Generation
Configure Apollo codegen in `apollo-codegen-config.json` and run generation script:
```bash
./generate-apollo.sh
```

### Makefile Commands
The project includes a focused Makefile for ticket scanner development:

```bash
# Setup and status
make setup              # Complete setup: check deps, fetch schema
make status             # Check project status and dependencies
make check-deps         # Check if required tools are installed

# Schema management
make fetch-schema       # Fetch GraphQL schema from localhost backend
make update-schema      # Fetch schema from backend
make watch-schema       # Watch for schema changes

# iOS project management
make build-ios          # Build iOS project (requires Xcode)
make test-ios           # Run iOS tests
make clean-ios          # Clean iOS build artifacts

# Code generation (manual)
make generate-apollo    # Show instructions for Apollo code generation
make generate-apollo-manual # Generate Apollo code (requires Apollo CLI)

# Validation
make validate-schema    # Validate GraphQL schema file exists
make validate-operations # Validate GraphQL operations exist

# Documentation
make docs               # Generate basic documentation

# Cleanup
make clean              # Clean all generated files
make clean-generated    # Clean generated Apollo code
make clean-all          # Clean everything

# Help
make help               # Show all available commands
```

### Adding New Features
1. Create new TCA features in `Features/` directory
2. Add corresponding GraphQL operations to backend
3. Create GraphQL operation files in `GraphQL/Operations/`
4. Run `make dev` to update schema from backend
5. Manually update `schema.graphqls` if needed
6. Add SwiftUI views for new functionality

### Testing
- Unit tests for TCA features
- Integration tests for API client
- UI tests for critical user flows

## Deployment

### Backend
- Deploy to production server
- Run database migrations
- Configure environment variables

### iOS App
- Archive in Xcode
- Upload to App Store Connect
- Submit for review

## Support

For technical support or questions, contact the development team or refer to the backend documentation in the main project repository.
