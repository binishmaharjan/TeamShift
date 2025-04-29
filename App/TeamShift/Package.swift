// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TeamShift",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v12)],
    products: [
        .library(name: "TeamShift", targets: ["TeamShift"]),
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SharedUIs", targets: ["SharedUIs"]),
        .library(name: "FeatureAuthentication", targets: ["FeatureAuthentication"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.58.2"),
    ],
    targets: [
        .target(
            name: "TeamShift",
            dependencies: [
                "SharedModels",
                "SharedUIs",
                "FeatureAuthentication"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SharedUIs",
            dependencies: [],
            resources: [
                .process("Resources"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
                .plugin(name: "AssetGenPlugin")
            ]
        ),
        .target(
            name: "FeatureAuthentication",
            dependencies: [
                "SharedUIs",
                "SharedModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .plugin(
            name: "AssetGenPlugin",
            capability: .buildTool()
        ),
    ]
)
