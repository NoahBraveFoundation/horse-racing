// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TicketScanner",
  platforms: [.iOS(.v26)],
  products: [
    .library(
      name: "TicketScannerKit",
      targets: ["TicketScannerKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.19.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-sharing", from: "2.7.0"),
    .package(url: "https://github.com/apollographql/apollo-ios", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-http-types", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-crypto", from: "3.0.0"),
    .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
    .package(path: "Generated/Schema"),
  ],
  targets: [
    .target(
      name: "TicketScannerKit",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Sharing", package: "swift-sharing"),
        .product(name: "Apollo", package: "apollo-ios"),
        .product(name: "ApolloAPI", package: "apollo-ios"),
        .product(name: "HorseRacingAPI", package: "Schema"),
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "Crypto", package: "swift-crypto"),
        .product(name: "Logging", package: "swift-log"),
      ],
      path: "Sources/TicketScannerKit"
    )
  ]
)
