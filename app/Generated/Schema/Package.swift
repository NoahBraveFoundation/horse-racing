// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "HorseRacingAPI",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_14),
    .tvOS(.v12),
    .watchOS(.v5),
  ],
  products: [
    .library(name: "HorseRacingAPI", targets: ["HorseRacingAPI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", exact: "1.23.0"),
  ],
  targets: [
    .target(
      name: "HorseRacingAPI",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
  ]
)
