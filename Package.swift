// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentView",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "PresentView",
            targets: ["PresentView"])
    ],
    targets: [
        .target(
            name: "PresentView")
    ]
)
