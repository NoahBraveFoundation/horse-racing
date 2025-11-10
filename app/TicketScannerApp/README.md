# Ticket Scanner App

iOS application for scanning tickets at the Horse Racing Fundraiser event.

## Structure

This is the iOS app target that depends on the `TicketScannerKit` Swift Package located in the parent directory.

## Building

1. Open `TicketScannerApp.xcodeproj` in Xcode
2. Select your development team in the project settings
3. Build and run (⌘R)

## Project Generation

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) for project file generation.

To regenerate the Xcode project after modifying `project.yml`:

```bash
xcodegen generate
```

## Dependencies

The app depends on:
- `TicketScannerKit` - Core library with business logic, features, and services
- All dependencies are managed through Swift Package Manager

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 6.0+
