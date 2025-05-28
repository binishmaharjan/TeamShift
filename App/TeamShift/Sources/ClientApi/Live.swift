import ClientAuthentication
import ClientUserStore
import Dependencies
import SharedModels

extension ApiClient: DependencyKey {
    public static let liveValue = ApiClient.live()
}

extension ApiClient {
    public static func live() -> ApiClient {
        let session = Session()
        
        return ApiClient(
            createUser: { try await session.createUser(withEmail: $0, password: $1) },
            signIn: { try await session.signIn(with: $0, password: $1) },
            signUpAsGuest: { try await session.signUpAsGuest() },
            signUpWithGoogle: { try await session.signUpWithGoogle() },
            signInWithGoogle: { try await session.signInWithGoogle() },
            sendPasswordReset: { try await session.sendPasswordReset(withEmail: $0) },
            linkAccount: { try await session.linkAccount(withEmail: $0, password: $1) },
            linkAccountWithGmail: { try await session.linkAccountWithGmail() },
            changePassword: { try await session.updatePassword(to: $0, oldPassword: $1) },
            deleteUser: { try await session.deleteUser() },
            deleteUserWithReAuthentication: { try await session.deleteUserWithReAuthentication(password: $0) },
            deleteUserWithGoogleReAuthentication: { try await session.deleteUserWithGoogleReAuthentication() },
            signOut: { try await session.signOut() },
            getCurrentUser: { try await session.getCurrentUser(uid: $0) },
            updateUser: { try await session.updateUser(for: $0, with: $1) },
            getAppConfig: { try await session.getAppConfig() }
        )
    }
}

extension ApiClient {
    actor Session {
        @Dependency(\.authenticationClient) var authenticationClient
        @Dependency(\.userStoreClient) var userStoreClient
        @MainActor let userSession = UserSession.shared
        
        func createUser(withEmail email: String, password: String) async throws {
            let user = try await authenticationClient.createUser(withEmail: email, password: password)
            try await userStoreClient.saveUser(user: user)
            
            await MainActor.run {
                userSession.appUser = user
            }
        }
        
        func signIn(with email: String, password: String) async throws {
            let uid = try await authenticationClient.signIn(withEmail: email, password: password)
            let user = try await userStoreClient.getUser(uid: uid)
              
            await MainActor.run {
                userSession.appUser = user
            }
        }
        
        func signUpAsGuest() async throws {
            let user = try await authenticationClient.signUpAsGuest()
            try await userStoreClient.saveUser(user: user)
            
            await MainActor.run {
                userSession.appUser = user
            }
        }
        
        func signUpWithGoogle() async throws {
            let user = try await authenticationClient.signUpWithGoogle()
            try await userStoreClient.saveUser(user: user)
            
            await MainActor.run {
                userSession.appUser = user
            }
        }
        
        func signInWithGoogle() async throws {
            let uid = try await authenticationClient.signInWithGoogle()
            let user = try await userStoreClient.getUser(uid: uid)
            
            await MainActor.run {
                userSession.appUser = user
            }
        }
        
        func sendPasswordReset(withEmail email: String) async throws {
            try await authenticationClient.sendPasswordReset(withEmail: email)
        }
        
        func linkAccount(withEmail email: String, password: String) async throws {
            guard let currentUser = await userSession.appUser else {
                throw AppError.internalError(.userNotFound)
            }
            
            try await authenticationClient.linkAccount(withEmail: email, password: password)
            
            let dict = currentUser.dictionaryBuilder()
                .email(email)
                .signInMethod(.email)
                .dictionary.asSendable
            
            try await userStoreClient.updateUser(uid: currentUser.id, fields: dict)
            
            await MainActor.run {
                userSession.appUser?.signInMethod = .email
            }
        }
        
        func linkAccountWithGmail() async throws {
            guard let currentUser = await userSession.appUser else {
                throw AppError.internalError(.userNotFound)
            }
            
            let newEmail = try await authenticationClient.linkAccountWithGmail()
            
            let dict = currentUser.dictionaryBuilder()
                .email(newEmail)
                .signInMethod(.google)
                .dictionary.asSendable
            
            try await userStoreClient.updateUser(uid: currentUser.id, fields: dict)
            
            await MainActor.run {
                userSession.appUser?.signInMethod = .google
            }
        }
        
        func updatePassword(to newPassword: String, oldPassword: String) async throws {
            try await authenticationClient.changePassword(to: newPassword, oldPassword: oldPassword)
        }
        
        func deleteUser() async throws {
            guard let currentUser = await userSession.appUser else {
                throw AppError.internalError(.userNotFound)
            }
            
            try await authenticationClient.deleteUser()
            try await userStoreClient.deleteUser(uid: currentUser.id)
        }
        
        func deleteUserWithReAuthentication(password: String) async throws {
            guard let currentUser = await userSession.appUser else {
                throw AppError.internalError(.userNotFound)
            }
            
            guard await userSession.isSignInMethod(.email), let email = currentUser.email else {
                throw AppError.internalError(.invalidUserData)
            }
            
            try await authenticationClient.reAuthenticate(withEmail: email, password: password)
            try await userStoreClient.deleteUser(uid: currentUser.id)
            try await authenticationClient.deleteUser()
        }
        
        func deleteUserWithGoogleReAuthentication() async throws {
            guard let currentUser = await userSession.appUser else {
                throw AppError.internalError(.userNotFound)
            }
            
            guard await userSession.isSignInMethod(.google) else {
                throw AppError.internalError(.invalidUserData)
            }
            
            try await authenticationClient.reAuthenticateWithGoogle()
            try await userStoreClient.deleteUser(uid: currentUser.id)
            try await authenticationClient.deleteUser()
        }
        
        func signOut() async throws {
            try await authenticationClient.signOut()
        }
        
        func getCurrentUser(uid: String) async throws {
            let user = try await userStoreClient.getUser(uid: uid)
            
            await MainActor.run {
                userSession.appUser = user
            }
        }
        
        func updateUser(for uid: String, with fields: SendableDictionary) async throws {
            try await userStoreClient.updateUser(uid: uid, fields: fields)
        }
        
        func getAppConfig() async throws -> AppConfig {
            try await userStoreClient.getAppConfig()
        }
    }
}
