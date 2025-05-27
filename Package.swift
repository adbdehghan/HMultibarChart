// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MultiBarChart",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MultiBarChart",
            targets: ["MultiBarChart"]) // The target that builds this library
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MultiBarChart",
            dependencies: []
        ),
    ]
)
