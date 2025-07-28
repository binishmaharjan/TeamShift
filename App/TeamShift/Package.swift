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
        /* Shared */
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SharedUIs", targets: ["SharedUIs"]),
        /* Features */
        .library(name: "AuthenticationFeature", targets: ["AuthenticationFeature"]),
        .library(name: "MainTabFeature", targets: ["MainTabFeature"]),
        .library(name: "ProfileFeature", targets: ["ProfileFeature"]),
        .library(name: "ScheduleFeature", targets: ["ScheduleFeature"]),
        .library(name: "WorkplaceFeature", targets: ["WorkplaceFeature"]),
        /* Clients */
        .library(name: "ApiClient", targets: ["ApiClient"]),
        .library(name: "AuthenticationClient", targets: ["AuthenticationClient"]),
        .library(name: "UserStoreClient", targets: ["UserStoreClient"]),
        .library(name: "UserSessionClient", targets: ["UserSessionClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        /* Kits */
        .library(name: "LocationKit", targets: ["LocationKit"]),
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
                "AuthenticationFeature",
                "MainTabFeature",
                "ApiClient",
                "UserSessionClient"
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
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SharedUIs",
            dependencies: [
                "SharedModels",
            ],
            resources: [
                .process("Resources"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
                .plugin(name: "AssetGenPlugin")
            ]
        ),
        .target(
            name: "AuthenticationFeature",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                "ApiClient",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "MainTabFeature",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                "ProfileFeature",
                "ScheduleFeature",
                "WorkplaceFeature"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ProfileFeature",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                "ApiClient",
                "UserSessionClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
                .plugin(name: "LicensePlugin")
            ]
        ),
        .target(
            name: "ScheduleFeature",
            dependencies: [
                "SharedUIs",
                "SharedModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "WorkplaceFeature",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                "ApiClient",
                "UserSessionClient",
                "LocationKit",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "ApiClient",
            dependencies: [
                "SharedModels",
                "AuthenticationClient",
                "UserStoreClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "AuthenticationClient",
            dependencies: [
                "SharedModels",
                "UserSessionClient",
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
            name: "UserSessionClient",
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
            name: "UserStoreClient",
            dependencies: [
                "SharedModels",
                "UserDefaultsClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ]
        ),
        .target(
            name: "LocationKit",
            dependencies: [
                "SharedUIs",
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
