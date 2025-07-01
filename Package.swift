// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "PresentView",
            targets: ["PresentView"]),
    ],
    targets: [
        .target(
            name: "PresentView"),

    ]
)
