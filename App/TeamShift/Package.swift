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
        .library(name: "FeatureMainTab", targets: ["FeatureMainTab"]),
        .library(name: "ClientAuthentication", targets: ["ClientAuthentication"]),
        .library(name: "ClientUserStore", targets: ["ClientUserStore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.58.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "11.12.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", exact: "8.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.9.2"),
    ],
    targets: [
        .target(
            name: "TeamShift",
            dependencies: [
                "SharedModels",
                "SharedUIs",
                "FeatureAuthentication",
                "FeatureMainTab",
                "ClientAuthentication",
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
                "SharedModels",
                "ClientAuthentication",
                "ClientUserStore",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "FeatureMainTab",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"), // TODO: remove once unrequired
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ClientAuthentication",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ClientUserStore",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
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
