import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

@DependencyClient
public struct ApiClient: Sendable {
    // MARK: Authentication
    
    /// Create new account for the user.
    ///
    /// - Parameter newAccount: User info for the new account
    /// - Returns: UserId
    public var createUser: @Sendable (_ withEmail: String, _ password: String) async throws -> Void
    /// SignIn the user.
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    ///   - password: Password for the account
    /// - Returns: UserId
    public var signIn: @Sendable (_ withEmail: String, _ password: String) async throws -> Void
    /// SignIn the user as guest.
    ///
    /// - Parameters none
    /// - Returns: UserId
    public var signUpAsGuest: @Sendable () async throws -> Void
    /// SignUp the with OAuth(Google).
    ///
    /// - Parameters none
    /// - Returns: UserId
    public var signUpWithGoogle: @Sendable () async throws -> Void
    /// SignIn the with OAuth(Google).
    ///
    /// - Parameters none
    /// - Returns: UserId
    public var signInWithGoogle: @Sendable () async throws -> Void
    /// Send Password Reset Email
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    /// - Returns: Void
    public var sendPasswordReset: @Sendable (_ withEmail: String) async throws -> Void
    /// Link Guest user to Email and password
    ///
    /// - Parameter email: User email id associated with user account.
    /// - Returns: Void
    public var linkAccount: @Sendable (_ withEmail: String, _ password: String) async throws -> Void
    /// Link Guest user to EGmail
    ///
    /// - Parameters:
    /// - Returns: Void
    public var linkAccountWithGmail: @Sendable () async throws -> Void
    /// Change User Password
    ///
    /// - Parameter
    ///     - newPassword: The new password user wants to set
    ///     - oldPassword: Current password
    /// - Returns: Void
    public var changePassword: @Sendable (_ to: String, _ oldPassword: String) async throws -> Void
    /// Delete user(Guest)
    ///
    /// - Parameter none
    /// - Returns: Void
    public var deleteUser: @Sendable () async throws -> Void
    /// Delete user after ReAuthentication
    ///
    /// - Parameters:
    ///   - email: Email Id of user
    ///   - password: Password for the account
    /// - Returns: Void
    public var deleteUserWithReAuthentication: @Sendable (_ password: String) async throws -> Void
    /// Delete user after ReAuthentication with Google
    ///
    /// - Parameters:
    /// - Returns: Void
    public var deleteUserWithGoogleReAuthentication: @Sendable () async throws -> Void
    /// SignOut User
    ///
    /// - Parameter none
    /// - Returns: Void
    public var signOut: @Sendable () async throws -> Void
    /// Get user data
    ///
    /// - Parameters:
    ///   - uid: UID of user
    /// - Returns: AppUser
    public var getCurrentUser: @Sendable (_ uid: String) async throws -> Void
    /// Update user data
    ///
    /// - Parameters:
    ///   - uid: UID of user
    ///   - fields fields to be updated
    /// - Returns: AppUser
    public var updateUser: @Sendable (_ uid: String, _ fields: SendableDictionary) async throws -> Void
    
    // MARK: UserStore
    
    /// Get App Config
    ///
    /// - Parameter none
    /// - Returns: AppUser
    public var getAppConfig: @Sendable () async throws -> AppConfig
    /// Create Workplace
    ///
    /// - Parameters:
    ///   - workplace: workplace detail
    /// - Returns: Void
    public var createWorkplace: @Sendable (_ workplace: Workplace) async throws -> Void
    /// Get All Workplace
    ///
    /// - Parameters:
    ///   - workplace: workplace detail
    /// - Returns: Void
    public var getWorkplace: @Sendable (_ user: AppUser) async throws -> [Workplace]
}

// MARK: DependencyValues
extension DependencyValues {
    public var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension ApiClient: TestDependencyKey {
    public static let testValue = ApiClient(
        createUser: unimplemented(),
        signIn: unimplemented(),
        signUpAsGuest: unimplemented(),
        signUpWithGoogle: unimplemented(),
        signInWithGoogle: unimplemented(),
        sendPasswordReset: unimplemented(),
        linkAccount: unimplemented(),
        linkAccountWithGmail: unimplemented(),
        changePassword: unimplemented(),
        deleteUser: unimplemented(),
        deleteUserWithReAuthentication: unimplemented(),
        deleteUserWithGoogleReAuthentication: unimplemented(),
        signOut: unimplemented(),
        getCurrentUser: unimplemented(),
        updateUser: unimplemented(),
        getAppConfig: unimplemented(),
        createWorkplace: unimplemented(),
        getWorkplace: unimplemented()
    )
}
