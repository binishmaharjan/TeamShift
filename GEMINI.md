# TeamShift iOS Project Guidelines

This document defines the structure, architecture, and conventions for the TeamShift iOS project. Adherence to these guidelines is required for all contributions.

## 1. Project Overview

TeamShift is a native iOS application designed to streamline team scheduling and management. The app allows users to create or join a 'Workplace', which serves as a central hub for their team.

The core functionalities include:
- **Authentication:** Secure user sign-up, sign-in, and account management.
- **Workplace Management:** Users can create, join, or manage team workplaces.
- **Scheduling:** View and manage work schedules and shifts within the context of a workplace.
- **User Profiles:** Users can manage their personal information, including display name, avatar, and password.

The application is structured around a main tab bar, providing easy access to the schedule, profile, and other key features. The primary data models are `AppUser`, `Workplace`, and various entities related to scheduling.

## 2. Core Architecture & Principles

- **Primary Language:** Swift
- **UI Framework:** SwiftUI
- **Architectural Pattern:** The project **must** follow a modular architecture. All features and services are encapsulated in their own Swift Packages.
- **Navigation:** All navigation and view flow control **must** be implemented using the **Coordinator Pattern**, as detailed in the next section.

## 3. Navigation & Coordinator Pattern

Navigation is handled exclusively by Coordinators, directed by ViewModels. This ensures a strict separation of concerns. The implementation **must** follow this pattern:

1.  **`Route` Enum in ViewModel:** Any `ViewModel` that needs to trigger navigation must define a nested `enum Route`. This enum lists all possible navigation destinations from its corresponding `View`.

2.  **ViewModel Initiates Navigation:** The `ViewModel` calls a method on its `Coordinator` instance to request a navigation change. It passes a case from its `Route` enum to the coordinator.

3.  **Coordinator Executes Navigation:** The `Coordinator` receives the `Route` and contains the logic to present the new view (e.g., by pushing a new `UIViewController` onto the navigation stack).

4.  **Coordinator Extensions for Separation:** To keep the Coordinator organized, navigation-handling methods **must** be defined in an `extension` of the Coordinator. This extension should be dedicated to a specific `ViewModel`. This cleanly separates the navigation logic that serves different views.

**Example Implementation:**

```swift
// In ProfileViewModel.swift
@Observable @MainActor
final class ProfileViewModel {
    enum Route {
        case showChangeAvatar
        case showLicense
    }
    
    private weak var coordinator: ProfileCoordinator?
    
    func listRowTapped(_ listRow: ProfileRow) {
        switch listRow {
        case .changeAvatar:
            coordinator?.profileRequestNavigation(for: .showChangeAvatar)
        case .license:
            coordinator?.profileRequestNavigation(for: .showLicense)
        // ...
        }
    }
}

// In ProfileCoordinator.swift
@MainActor
public final class ProfileCoordinator: FlowCoordinator {
    // ... core coordinator properties and start() method
}

// MARK: - Profile Navigation
extension ProfileCoordinator {
    func profileRequestNavigation(for route: ProfileViewModel.Route) {
        switch route {
        case .showChangeAvatar:
            pushChangeAvatarView()
        case .showLicense:
            pushLicenseView()
        }
    }
    
    private func pushChangeAvatarView() { /* ... */ }
    private func pushLicenseView() { /* ... */ }
}
```

## 4. Project Structure & Conventions

The project's directory structure is strictly defined. All new code must be placed in the appropriate module according to these rules.

- **`App/TeamShift/`**: The root of the Swift Package containing all source code.
  - **`Package.swift`**: The manifest file defining all modules and their dependencies. All module definitions and dependencies must be declared here.
  - **`Sources/`**: All source code is organized within this directory, categorized as follows:
    - **`*Feature/`**: A module for a self-contained user-facing feature (e.g., `ProfileFeature`). New features must be created in their own module and include `View`, `ViewModel`, and `Coordinator` components.
    - **`*Client/`**: A module that provides a client for an external service or data source (e.g., `ApiClient`, `UserStoreClient`). These modules abstract data and API access. **All public APIs in these modules must be fully documented.**
    - **`*Kit/`**: A module that provides a wrapper around a system framework or a self-contained set of tools (e.g., `LocationKit`). **All public APIs in these modules must be fully documented.**
    - **`SharedUIs/`**: A module for reusable SwiftUI views, modifiers, and UI resources (colors, fonts) that are shared across multiple features.
    - **`SharedModels/`**: A module for data models (e.g., `AppUser`) and extensions shared by multiple modules.
    - **`Plugins/`**: Custom SwiftPM build tool plugins.

## 5. Code Quality & Tooling

- **Code Style:** All Swift code **must** conform to the rules defined in the `.swiftlint.yml` file. SwiftLint runs automatically as a build plugin in Xcode. To run it manually from the command line, use `swift package lint`.
- **API Documentation:** For shared modules like `*Client` and `*Kit`, all public functions and properties **must** be documented using Swift's three-slash (`///`) doc-comment syntax. This documentation should clearly explain the purpose, parameters, and return value of the API so that it is visible to developers in Xcode.
- **Dependency Management:**
  - **SwiftPM:** All Swift dependencies are managed in `Package.swift`.
  - **Bundler:** All Ruby-based tools (e.g., Fastlane) are managed in the `Gemfile`.
- **Automation:** All build, test, and release processes are automated via Fastlane. Review the `fastlane/Fastfile` for available lanes.

## 6. Standard Workflows

- **Adding a New Feature:**
  1. Create a new directory under `App/TeamShift/Sources/` named `YourFeature`.
  2. Add a new library target to the `targets` array in `Package.swift` for your feature.
  3. Within your feature module, create `Coordinator`, `View`, and `ViewModel` directories and files.
  4. Add the new feature module as a dependency to the main `TeamShift` app target in `Package.swift`.

- **Adding a New Swift Dependency:**
  1. Add the package to the `dependencies` array in `Package.swift`.
  2. Add the new package as a dependency to the relevant target(s) in `Package.swift`.

- **Building for Development:**
  1. Open `App/TeamShift.xcworkspace`.
  2. Select the `Development` scheme and a target simulator or device.
  3. Build and run from Xcode.
