// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NnexKit",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "NnexKit",
            targets: ["NnexKit"]),
        .library(
            name: "NnexSharedTestHelpers",
            targets: ["NnexSharedTestHelpers"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/kareman/SwiftShell", from: "5.0.0"),
        .package(url: "https://github.com/nikolainobadi/NnGitKit.git", branch: "main"),
        .package(url: "https://github.com/nikolainobadi/NnSwiftDataKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "NnexKit",
            dependencies: [
                "Files",
                "SwiftShell",
                "NnSwiftDataKit",
                .product(name: "GitShellKit", package: "NnGitKit"),
            ]
        ),
        .target(
            name: "NnexSharedTestHelpers",
            dependencies: [
                "NnexKit"
            ]
        ),
        .testTarget(
            name: "NnexKitTests",
            dependencies: [
                "NnexKit",
                "NnexSharedTestHelpers"
            ]
        ),
    ]
)
