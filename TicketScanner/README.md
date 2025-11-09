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

- **Magic Link Authentication**: Passwordless email-based authentication with deep link support
- **Secure Token Management**: JWT tokens stored locally and automatically included in API requests
- **Barcode Scanning**: Real-time ticket scanning with camera integration
- **Duplicate Prevention**: Prevents scanning the same ticket multiple times
- **Location Tracking**: Records where tickets are scanned
- **Statistics Dashboard**: Real-time scanning statistics and analytics
- **Offline Support**: Handles network failures gracefully

### Authentication Flow

The app uses a magic link authentication system:
1. User enters email address
2. Backend sends email with magic link (containing token)
3. User taps link → app opens via deep link (`ticketscanner://auth-callback?token=...`)
4. App validates token with backend and receives user profile
5. Token is stored locally and automatically included in all API requests
6. User stays logged in across app launches

**Deep Link Support:**
- URL Scheme: `ticketscanner://`
- Universal Links: `https://horses.noahbrave.org/auth-callback`

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
4. Regenerate Apollo code: `make generate-apollo`

### GraphQL Code Generation

The project uses Apollo iOS for type-safe GraphQL code generation. Generated code is checked into source control in `Generated/Schema/`.

**Regenerate code after schema or operation changes:**
```bash
make generate-apollo
```

This will:
1. Install Apollo iOS CLI if needed (using Swift Package Manager)
2. Generate Swift types from your GraphQL operations
3. Create type-safe query and mutation classes in `Generated/Schema/`

**Schema management:**
```bash
make update-schema      # Download latest schema from backend (auto-updates schema.graphqls)
```

**Full setup from scratch:**
```bash
make setup              # Fetch schema + generate code
```

### Makefile Commands
The project includes a focused Makefile for ticket scanner development:

```bash
# Setup and status
make setup              # Complete setup: fetch schema and generate code
make status             # Check project status and dependencies
make check-deps         # Check if required tools are installed

# Schema management
make update-schema      # Fetch schema from backend (auto-updates schema.graphqls)
make watch-schema       # Watch for schema changes (polls every 30s)

# Code generation
make generate-apollo    # Generate Apollo Swift code from GraphQL operations
make clean-generated    # Clean generated Apollo code

# iOS project management
make build-ios          # Build iOS project (requires Xcode)
make test-ios           # Run iOS tests
make clean-ios          # Clean iOS build artifacts

# Validation
make validate-schema    # Validate GraphQL schema file exists
make validate-operations # Validate GraphQL operations exist

# Documentation
make docs               # Generate basic documentation

# Development workflow
make dev                # Update schema and regenerate code

# Cleanup
make clean              # Clean all generated files
make clean-all          # Clean everything

# Help
make help               # Show all available commands
```

**Note:** Generated Apollo code in `Generated/` is checked into source control. This ensures the project builds without requiring the backend to be running.

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
