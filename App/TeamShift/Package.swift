// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
        .library(name: "FeatureProfile", targets: ["FeatureProfile"]),
        .library(name: "FeatureSchedule", targets: ["FeatureSchedule"]),
        .library(name: "FeatureWorkplace", targets: ["FeatureWorkplace"]),
        .library(name: "ClientApi", targets: ["ClientApi"]),
        .library(name: "ClientAuthentication", targets: ["ClientAuthentication"]),
        .library(name: "ClientUserStore", targets: ["ClientUserStore"]),
        .library(name: "ClientUserSession", targets: ["ClientUserSession"]),
        .library(name: "ClientUserDefaults", targets: ["ClientUserDefaults"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.58.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "11.12.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", exact: "8.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.9.2"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "601.0.1")
    ],
    targets: [
        .target(
            name: "TeamShift",
            dependencies: [
                "SharedModels",
                "SharedUIs",
                "FeatureAuthentication",
                "FeatureMainTab",
                "ClientApi",
                "ClientUserSession"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .macro(
            name: "SharedMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                "SharedMacros",
            ],
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
                "ClientApi",
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
                "FeatureProfile",
                "FeatureSchedule",
                "FeatureWorkplace"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "FeatureProfile",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                "ClientApi",
                "ClientUserSession"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
                .plugin(name: "LicensePlugin")
            ]
        ),
        .target(
            name: "FeatureSchedule",
            dependencies: [
                "SharedUIs",
                "SharedModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "FeatureWorkplace",
            dependencies: [
                "SharedUIs",
                "SharedModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ClientApi",
            dependencies: [
                "SharedModels",
                "ClientAuthentication",
                "ClientUserStore",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ClientAuthentication",
            dependencies: [
                "SharedModels",
                "ClientUserSession",
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
            name: "ClientUserSession",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ClientUserStore",
            dependencies: [
                "SharedModels",
                "ClientUserDefaults",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ClientUserDefaults",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .plugin(
            name: "AssetGenPlugin",
            capability: .buildTool()
        ),
        .plugin(
            name: "LicensePlugin",
            capability: .buildTool()
        ),
    ]
)
