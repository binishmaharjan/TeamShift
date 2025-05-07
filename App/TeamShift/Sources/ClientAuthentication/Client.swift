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
    public var createUser: @Sendable (_ withEmail: String, _ password: String) async throws -> AppUser
    /// SignIn the user.
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    ///   - password: Password for the account
    /// - Returns: UserId
    public var signIn: @Sendable (_ withEmail: String, _ password: String) async throws -> String
    /// SignIn the user as guest.
    ///
    /// - Parameters none
    /// - Returns: UserId
    public var signUpAsGuest: @Sendable () async throws -> AppUser
    /// SignUp the with OAuth(Google).
    ///
    /// - Parameters none
    /// - Returns: UserId
    public var signUpWithGoogle: @Sendable () async throws -> AppUser
    /// SignIn the with OAuth(Google).
    ///
    /// - Parameters none
    /// - Returns: UserId
    public var signInWithGoogle: @Sendable () async throws -> String
    /// Send Password Reset Email
    ///
    /// - Parameter email: User email id associated with user account.
    /// - Returns: Void
    public var sendPasswordReset: @Sendable (_ withEmail: String) async throws -> Void
    /// SignOut User
    ///
    /// - Parameter none
    /// - Returns: Void
    public var signOut: @Sendable () async throws -> Void
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
        signIn: unimplemented(),
        signUpAsGuest: unimplemented(),
        signUpWithGoogle: unimplemented(),
        signInWithGoogle: unimplemented(),
        sendPasswordReset: unimplemented(),
        signOut: unimplemented()
    )
}
