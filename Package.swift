// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WalkthroughKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "WalkthroughKit",
            targets: ["WalkthroughKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "WalkthroughKit",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
