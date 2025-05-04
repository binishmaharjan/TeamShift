import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

@DependencyClient
public struct UserStoreClient: Sendable {
    public var saveUser: @Sendable (_ user: AppUser) async throws -> Void
    public var getUser: @Sendable (_ uid: String) async throws -> AppUser
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
        saveUser: unimplemented(),
        getUser: unimplemented()
    )
}
