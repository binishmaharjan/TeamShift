import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

@DependencyClient
public struct UserStoreClient: Sendable {
    public var saveUser: @Sendable (_ user: AppUser) async throws -> Void
    public var getUser: @Sendable (_ uid: String) async throws -> AppUser
    public var updateUser: @Sendable (_ uid: String, _ fields: SendableDictionary) async throws -> Void
    public var deleteUser: @Sendable (_ uid: String) async throws -> Void
    public var getAppConfig: @Sendable () async throws -> AppConfig
    public var createWorkplace: @Sendable (_ workplace: Workplace) async throws -> Void
    public var getWorkplace: @Sendable (_ user: AppUser) async throws -> [Workplace]
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
        getUser: unimplemented(),
        updateUser: unimplemented(),
        deleteUser: unimplemented(),
        getAppConfig: unimplemented(),
        createWorkplace: unimplemented(),
        getWorkplace: unimplemented()
    )
}
