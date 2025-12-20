import ProjectDescription
import ProjectDescriptionHelpers

/*:
 # Project Architecture Overview
 
 This configuration uses a **Single Target, Multi-Configuration** strategy.
 Instead of creating separate targets for Dev, Staging, and Prod (which duplicates code),
 we use a single target (`MyApp`) and change its behavior using **Build Configurations**.
 
 - **Development**: Uses 'Debug' settings (slow, enables debugger). Connects to Dev backend.
 - **Staging**: Uses 'Release' settings (fast, optimized). Connects to Staging backend.
 - **Production**: Uses 'Release' settings. Connects to Prod backend.
 
 All environment-specific variables (Bundle ID, App Name, API Keys) are stored in external
 `.xcconfig` files located in `App/Configuration/`.
 */

// 1. Define configurations mapping to specific .xcconfig files
let configurations: [Configuration] = [
    .debug(name: "Development", xcconfig: "Configuration/Development.xcconfig"),
    .release(name: "Staging", xcconfig: "Configuration/Staging.xcconfig"),
    .release(name: "Production", xcconfig: "Configuration/Production.xcconfig")
]

let targetName = AppConfiguration.appName

// 2. Define the Single Target
let appTarget = Target.target(
    name: targetName,
    destinations: [.iPhone], // Restrict to iPhone only (No iPad/Mac)
    product: .app,
    bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)", // Reads from the active .xcconfig
    deploymentTargets: .iOS(AppConfiguration.targetVersion),
    infoPlist: .file(path: "Resources/Info.plist"), // Use explicit file
    sources: ["Sources/**"],
    // Exclude Info.plist from resources to prevent "Multiple commands produce" error
    resources: [.glob(pattern: "Resources/**", excluding: ["Resources/Info.plist"])],
    dependencies: [
        .package(product: "TeamShiftKit") // Depends only on the Umbrella Framework
    ],
    settings: .settings(
        configurations: configurations, // Apply configurations
        defaultSettings: .recommended( // Set SWIFT_VERSION manually(xcconfig), not from Tuist
            excluding: [
                "SWIFT_VERSION",
                "ASSETCATALOG_COMPILER_APPICON_NAME"
            ]
        )
    )
)

// 3. Define Custom Schemes (Dev, Staging, Prod)
let schemes: [Scheme] = [
    // Development: Debug mode, used for daily coding
    .scheme(
        name: "Development",
        shared: true,
        buildAction: .buildAction(targets: [.target(targetName)]),
        runAction: .runAction(configuration: "Development"),
        archiveAction: .archiveAction(configuration: "Development"),
        profileAction: .profileAction(configuration: "Development"),
        analyzeAction: .analyzeAction(configuration: "Development")
    ),
    // Staging: Release mode, used for QA
    .scheme(
        name: "Staging",
        shared: true,
        buildAction: .buildAction(targets: [.target(targetName)]),
        runAction: .runAction(configuration: "Staging"),
        archiveAction: .archiveAction(configuration: "Staging"),
        profileAction: .profileAction(configuration: "Staging"),
        analyzeAction: .analyzeAction(configuration: "Staging")
    ),
    // Production: Release mode, used for App Store
    .scheme(
        name: "Production",
        shared: true,
        buildAction: .buildAction(targets: [.target(targetName)]),
        runAction: .runAction(configuration: "Production"),
        archiveAction: .archiveAction(configuration: "Production"),
        profileAction: .profileAction(configuration: "Production"),
        analyzeAction: .analyzeAction(configuration: "Production")
    )
]

// 4. Define the Project
let project = Project(
    name: targetName,
    options: .options(
        automaticSchemesOptions: .disabled, // Disable default "MyApp" schemes
        disableBundleAccessors: true, // Disable TuistBundle+MyApp generation
        disableSynthesizedResourceAccessors: true // Disable TuistAssets+MyApp generation
    ),
    packages: [
        .package(path: "../TeamShiftKit")
    ],
    settings: .settings(configurations: configurations),
    targets: [appTarget],
    schemes: schemes, // Register custom schemes
    additionalFiles: [
        "Configuration/**"
    ],
    resourceSynthesizers: [] // Ensure no asset files are generated
)
