// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Analytics",
    products: [
        .library(name: "Analytics", targets: ["Analytics"]),
        .library(name: "CrashReporting", targets: ["CrashReporting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mixpanel/mixpanel-swift", from: "4.0.4"),
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "7.31.4"),
    ],
    targets: [
        .target(
            name: "Analytics",
            dependencies: [
                .product(name: "Mixpanel", package: "mixpanel-swift"),
            ]
        ),
        .target(
            name: "CrashReporting",
            dependencies: [
                .product(name: "Sentry", package: "sentry-cocoa"),
            ]
        ),
    ]
)
