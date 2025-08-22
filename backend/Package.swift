// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HorseRacingBackend",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/alexsteinerde/graphql-kit.git", from: "2.0.0"),
        .package(url: "https://github.com/alexsteinerde/graphiql-vapor.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor-community/sendgrid-kit.git", from: "3.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "HorseRacingBackend",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "GraphQLKit", package: "graphql-kit"),
                .product(name: "GraphiQLVapor", package: "graphiql-vapor"),
                .product(name: "SendGridKit", package: "sendgrid-kit"),
            ],
        ),
    ]
)
