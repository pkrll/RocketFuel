// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Resources",
    products: [
        .library(name: "Resources", targets: ["Resources"]),
    ],
    targets: [
        .target(
            name: "Resources",
            dependencies: [],
            resources: [
                .process("Localizable.strings")
            ]
        ),
    ]
)
