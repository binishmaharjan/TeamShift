import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

@DependencyClient
public struct UserStoreClient: Sendable {
}

// MARK: DependencyValues
extension DependencyValues {
    public var userStoreClient: UserStoreClient {
        get { self[UserStoreClient.self] }
        set { self[UserStoreClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension UserStoreClient: TestDependencyKey {
    public static let testValue = UserStoreClient(
    )
}
