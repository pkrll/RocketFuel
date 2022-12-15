// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HotKeys",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "HotKeys", targets: ["HotKeys"]),
    ],
    targets: [
        .target(name: "HotKeys", dependencies: []),
    ]
)
