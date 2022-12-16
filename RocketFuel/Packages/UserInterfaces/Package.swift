// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserInterfaces",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "UserInterfaces", targets: ["UserInterfaces"]),
    ],
    dependencies: [
        .package(path: "../HotKeys"),
    ],
    targets: [
        .target(
            name: "UserInterfaces",
            dependencies: [
                "HotKeys",
            ]
        ),
    ]
)
