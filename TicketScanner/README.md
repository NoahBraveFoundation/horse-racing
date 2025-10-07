# Ticket Scanner App

A modern iOS app built with SwiftUI and The Composable Architecture (TCA) for scanning tickets at the NoahBRAVE Foundation horse racing fundraiser event.

## Features

- **Admin Authentication**: Secure login for admin users
- **Barcode Scanning**: Real-time ticket scanning with camera integration
- **Duplicate Prevention**: Prevents scanning the same ticket multiple times
- **Location Tracking**: Records where tickets are scanned
- **Statistics Dashboard**: Real-time scanning statistics and analytics
- **Offline Support**: Handles network failures gracefully

## Architecture

### Backend (Swift/Vapor)
- **GraphQL API**: Modern API with type-safe queries and mutations
- **PostgreSQL Database**: Reliable data storage with proper relationships
- **Admin Authentication**: Simplified to allow any admin user to scan tickets
- **Real-time Updates**: Live statistics and scan tracking

### iOS App (SwiftUI/TCA)
- **The Composable Architecture**: Modern TCA 1.0+ with @ObservableState
- **Apollo GraphQL**: Type-safe GraphQL client with code generation
- **SwiftUI**: Modern, declarative UI framework
- **AVFoundation**: Camera integration for barcode scanning
- **Core Location**: Location services for scan tracking

## Project Structure

```
TicketScanner/
├── TicketScanner.xcodeproj/
├── GraphQL/
│   └── Operations/
│       ├── Login.graphql
│       ├── ScanTicket.graphql
│       ├── ScanningStats.graphql
│       ├── TicketByBarcode.graphql
│       └── RecentScans.graphql
├── Generated/
│   └── Schema/ (Apollo generated code)
├── TicketScanner/
│   ├── App/
│   │   └── TicketScannerApp.swift
│   ├── Core/
│   │   ├── Models/
│   │   │   ├── Ticket.swift
│   │   │   ├── TicketScan.swift
│   │   │   └── ScanResult.swift
│   │   ├── Services/
│   │   │   ├── APIClient.swift
│   │   │   ├── ApolloClient.swift
│   │   │   ├── BarcodeScanner.swift
│   │   │   └── LocationService.swift
│   │   └── Utils/
│   │       ├── Constants.swift
│   │       └── Extensions.swift
│   ├── Features/
│   │   ├── Authentication/
│   │   │   ├── AuthenticationFeature.swift
│   │   │   └── LoginView.swift
│   │   ├── Scanning/
│   │   │   ├── ScanningFeature.swift
│   │   │   ├── ScanningView.swift
│   │   │   └── ScanResultView.swift
│   │   └── Stats/
│   │       └── StatsView.swift
│   └── Resources/
│       └── Info.plist
├── schema.graphqls
├── apollo-codegen-config.json
├── generate-apollo.sh
└── Package.swift
```

## Backend Changes

### New Database Tables
- `ticket_scans`: Records all ticket scanning activities
- Updated `tickets` table with scanning fields
- Updated `users` table (simplified - no separate scanner permissions)

### New GraphQL Operations
- `scanTicket`: Scan a ticket by ID
- `undoScan`: Undo a previous scan
- `scanningStats`: Get scanning statistics
- `ticketByBarcode`: Find ticket by barcode
- `recentScans`: Get recent scanning activity

## Installation

### Backend Setup
1. Navigate to the backend directory
2. Run migrations: `swift run HorseRacingBackend migrate`
3. Start the server: `swift run HorseRacingBackend serve`

### iOS App Setup
1. Open `TicketScanner.xcodeproj` in Xcode
2. Check dependencies: `make check-deps`
3. Complete setup: `make setup` (checks deps, fetches schema)
4. Build and run on device or simulator

### Development Workflow
- **Check project status**: `make status`
- **Update schema from backend**: `make dev`
- **Fetch schema from backend**: `make fetch-schema`
- **Build iOS project**: `make build-ios`
- **Run iOS tests**: `make test-ios`

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
