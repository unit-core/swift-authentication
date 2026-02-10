// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftAuthentication",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swift-authentication",
            targets: ["swift-authentication"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/unit-core/swift-composable-architecture", exact: .init(1, 23, 1)),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift-authentication",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "swift-authenticationTests",
            dependencies: ["swift-authentication"]
        ),
    ]
)
