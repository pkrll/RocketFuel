// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "Core", targets: ["Core"]),
    ],
    dependencies: [
        .package(path: "../HotKeys"),
        .package(path: "../MenuBarExtras"),
        .package(path: "../Resources"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "MenuBarExtras",
                "HotKeys",
                "Resources",
            ]
        )
    ]
)
