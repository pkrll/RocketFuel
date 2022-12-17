// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "Constants", targets: ["Constants"]),
    ],
    dependencies: [
        .package(path: "../Analytics"),
        .package(path: "../HotKeys"),
        .package(path: "../LoginItem"),
        .package(path: "../MenuBarExtras"),
        .package(path: "../Resources"),
        .package(path: "../SleepControl"),
        .package(path: "../UserInterfaces"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Analytics",
                "Constants",
                .product(name: "CrashReporting", package: "Analytics"),
                "HotKeys",
                "LoginItem",
                "MenuBarExtras",
                "Resources",
                "SleepControl",
                "UserInterfaces",
            ]
        ),
        .target(
            name: "Constants",
            dependencies: [
                "Resources",
            ]
        ),
    ]
)
