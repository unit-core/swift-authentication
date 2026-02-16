// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-authentication",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UnitcoreAuthentication",
            targets: ["UnitcoreAuthentication"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/unit-core/swift-composable-architecture", exact: .init(1, 23, 1)),
        .package(url: "https://github.com/unit-core/swift-snapshot-testing", exact: .init(1, 18, 9)),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UnitcoreAuthentication",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "UnitcoreAuthenticationTests",
            dependencies: [
                "UnitcoreAuthentication",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ]
)
