// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TeamShift",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v12)],
    products: [
        .library(
            name: "TeamShift",
            targets: [
                "TeamShift"
            ]
        ),
    ],
    targets: [
        .target(
            name: "TeamShift")
        ,
    ]
)
