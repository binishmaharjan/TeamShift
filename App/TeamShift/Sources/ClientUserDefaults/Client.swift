import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

@DependencyClient
public struct UserDefaultsClient: Sendable {
    public var appUser: @Sendable () -> AppUser?
    public var setAppUser: @Sendable (AppUser?) -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

// MARK: Dependency
extension UserDefaultsClient: TestDependencyKey {
    public static let testValue = UserDefaultsClient(
        appUser: unimplemented(placeholder: .mockUser),
        setAppUser: unimplemented()
    )
    
    public static let previewValue = UserDefaultsClient(
        appUser: { .mockUser },
        setAppUser: unimplemented()
    )
}

extension AppUser {
    static let mockUser = AppUser(
        id: "62x2j84hM9YCSrtiNwhg2F86NSv2",
        username: "Mock User",
        email: nil,
        signInMethod: .guest,
        avatar: Avatar(colorTemplate: .redOrange, iconData: .icnMan3),
        createdDate: .now
    )
}
