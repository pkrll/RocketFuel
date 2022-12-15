// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MenuBarExtras",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "MenuBarExtras", targets: ["MenuBarExtras"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "MenuBarExtras", dependencies: [
            
        ])
    ]
)
