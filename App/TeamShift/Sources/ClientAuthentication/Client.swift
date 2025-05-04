import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

@DependencyClient
public struct AuthenticationClient: Sendable {
    /// Create new account for the user.
    ///
    /// - Parameter newAccount: User info for the new account
    /// - Returns: UserId
    public var createUser: @Sendable (_ withEmail: String, _ password: String) async throws -> String
    /// SignIn the user.
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    ///   - password: Password for the account
    /// - Returns: UserId
    public var signIn: @Sendable (_ withEmail: String, _ password: String) async throws -> String
}

// MARK: DependencyValues
extension DependencyValues {
    public var authenticationClient: AuthenticationClient {
        get { self[AuthenticationClient.self] }
        set { self[AuthenticationClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension AuthenticationClient: TestDependencyKey {
    public static let testValue = AuthenticationClient(
        createUser: unimplemented(),
        signIn: unimplemented()
    )
}
