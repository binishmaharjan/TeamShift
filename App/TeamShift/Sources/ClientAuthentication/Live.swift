import Dependencies
import Firebase
@preconcurrency import FirebaseAuth
import Foundation
@preconcurrency import GoogleSignIn
@preconcurrency import GoogleSignInSwift
import SharedModels

// MARK: Dependency (liveValue)
extension AuthenticationClient: DependencyKey {
    public static let liveValue = AuthenticationClient.live()
}

extension AuthenticationClient {
    public static func live() -> AuthenticationClient {
        let session = Session()
        
        return AuthenticationClient(
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
            deleteUserWithReAuthentication: { try await session.deleteUserWithReAuthentication(withEmail: $0, password: $1) },
            deleteUserWithGoogleReAuthentication: { try await session.deleteUserWithGoogleReAuthentication() },
            signOut: { try await session.signOut() }
        )
    }
}

extension AuthenticationClient {
    actor Session {
        func createUser(withEmail email: String, password: String) async throws -> AppUser {
            do {
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                
                let changeRequest = authDataResult.user.createProfileChangeRequest()
                changeRequest.displayName = email.toName
                try await changeRequest.commitChanges()
                
                return AppUser(
                    id: authDataResult.user.uid,
                    username: authDataResult.user.displayName,
                    email: authDataResult.user.email,
                    signInMethod: .email,
                    createdDate: .now
                )
            } catch {
                throw mapError(error)
            }
        }
        
        func signIn(with email: String, password: String) async throws -> String {
            do {
                let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
                return authDataResult.user.uid
            } catch {
                throw mapError(error)
            }
        }
        
        func signUpAsGuest() async throws -> AppUser {
            do {
                let authDataResult = try await Auth.auth().signInAnonymously()
                
                let changeRequest = authDataResult.user.createProfileChangeRequest()
                changeRequest.displayName = generateRandomUsername()
                try await changeRequest.commitChanges()
                
                return AppUser(
                    id: authDataResult.user.uid,
                    username: authDataResult.user.displayName,
                    email: authDataResult.user.email,
                    signInMethod: .guest,
                    createdDate: .now
                )
            } catch {
                throw mapError(error)
            }
        }
        
        func signUpWithGoogle() async throws -> AppUser {
            do {
                let gidGoogleUser = try await oAuthGoogleSignIn()
                
                guard let idToken = gidGoogleUser.idToken else {
                    throw AppError.apiError(.authenticationFailed("ID Token Missing"))
                }
                
                let accessToken = gidGoogleUser.accessToken
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                
                let authDataResult = try await Auth.auth().signIn(with: credentials)
                let changeRequest = authDataResult.user.createProfileChangeRequest()
                changeRequest.displayName = gidGoogleUser.profile?.name
                try await changeRequest.commitChanges()
                
                return AppUser(
                    id: authDataResult.user.uid,
                    username: authDataResult.user.displayName,
                    email: authDataResult.user.email,
                    signInMethod: .google,
                    createdDate: .now
                )
            } catch {
                throw mapError(error)
            }
        }
        
        func signInWithGoogle() async throws -> String {
            do {
                let gidGoogleUser = try await oAuthGoogleSignIn()
                guard let idToken = gidGoogleUser.idToken else {
                    throw AppError.apiError(.authenticationFailed("Failed to get Google authentication token"))
                }
                
                let accessToken = gidGoogleUser.accessToken
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                
                let authDataResult = try await Auth.auth().signIn(with: credentials)
                return authDataResult.user.uid
            } catch {
                throw mapError(error)
            }
        }
        
        func sendPasswordReset(withEmail email: String) async throws {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
            } catch {
                throw mapError(error)
            }
        }
        
        func linkAccount(withEmail email: String, password: String) async throws {
            do {
                guard let currentUser = Auth.auth().currentUser, currentUser.isAnonymous else {
                    throw AppError.apiError(.authenticationFailed("User is not anonymous"))
                }
                
                let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
                
                _ = try await currentUser.link(with: credentials)
            } catch {
                throw mapError(error)
            }
        }
        
        func linkAccountWithGmail() async throws -> String? {
            do {
                guard let currentUser = Auth.auth().currentUser, currentUser.isAnonymous else {
                    throw AppError.apiError(.authenticationFailed("User is not anonymous"))
                }
                
                let gidGoogleUser = try await oAuthGoogleSignIn()
                guard let idToken = gidGoogleUser.idToken else {
                    throw AppError.apiError(.authenticationFailed("Failed to get Google authentication token"))
                }
                
                let accessToken = gidGoogleUser.accessToken
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                
                _ = try await currentUser.link(with: credentials)
                return gidGoogleUser.profile?.email
            } catch {
                throw mapError(error)
            }
        }
        
        func updatePassword(to newPassword: String, oldPassword: String) async throws {
            do {
                let currentUser = Auth.auth().currentUser
                let email = currentUser?.email ?? ""
                
                let credentials = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
                let isReAuthenticated = try await reAuthenticate(with: credentials)
                
                guard isReAuthenticated else {
                    throw AppError.apiError(.authenticationFailed("Failed to ReAuthenticate"))
                }
                
                try await currentUser?.updatePassword(to: newPassword)
            } catch {
                throw mapError(error)
            }
        }
        
        func deleteUser() async throws {
            let currentUser = Auth.auth().currentUser
            try await currentUser?.delete()
        }
        
        func deleteUserWithReAuthentication(withEmail email: String, password: String) async throws {
            do {
                let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
                let isReAuthenticated = try await reAuthenticate(with: credentials)
                
                guard isReAuthenticated else {
                    throw AppError.apiError(.authenticationFailed("Failed to Authenticate"))
                }
                
                try await deleteUser()
            } catch {
                throw mapError(error)
            }
        }
        
        func deleteUserWithGoogleReAuthentication() async throws {
            do {
                let gidGoogleUser = try await oAuthGoogleSignIn()
                guard let idToken = gidGoogleUser.idToken else {
                    throw AppError.apiError(.authenticationFailed("Failed to get Google authentication token"))
                }
                
                let accessToken = gidGoogleUser.accessToken
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                let isReAuthenticated = try await reAuthenticate(with: credentials)
                
                guard isReAuthenticated else {
                    throw AppError.apiError(.authenticationFailed("Failed to authenticate"))
                }
                
                try await deleteUser()
            } catch {
                throw mapError(error)
            }
        }
        
        func signOut() async throws {
            do {
                try Auth.auth().signOut()
            } catch {
                throw mapError(error)
            }
        }
        
        // func reAuthenticate
        private func reAuthenticate(with credentials: AuthCredential) async throws -> Bool {
            let currentUser = Auth.auth().currentUser
            let authResult = try await currentUser?.reauthenticate(with: credentials)
            return authResult?.user != nil
        }
        
        @MainActor
        private func oAuthGoogleSignIn() async throws -> GIDGoogleUser {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AppError.apiError(.authenticationFailed("Google Sign In not configured"))
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                throw AppError.apiError(.authenticationFailed("Failed to get Root"))
            }
            
            let gIDSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let gidGoogleUser = gIDSignInResult.user
            return gidGoogleUser
        }
        
        private func generateRandomUsername() -> String {
            // the pool of characters to choose
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomCharacters = (0..<10).map { _ -> Character in
                // Select a random character from the allowed set
                // Force unwrap is safe here because 'characters' is guaranteed non-empty
                characters.randomElement()!
            }
            return "user_" + String(randomCharacters)
        }
    }
}

// MARK: Error
extension AuthenticationClient.Session {
    private func mapError(_ error: Error) -> AppError {
        if let nsError = error as NSError?, nsError.domain == AuthErrorDomain {
            switch AuthErrorCode(rawValue: nsError.code) {
            case .userNotFound:
                return .apiError(.userNotFound)
                
            case .wrongPassword:
                return .apiError(.invalidCredentials)
                
            case .emailAlreadyInUse:
                return .apiError(.emailAlreadyInUse)
                
            case .networkError:
                return .apiError(.networkTimeout)
                
            case .tooManyRequests:
                return .apiError(.rateLimited)
                
            default:
                return .apiError(.authenticationFailed(error.localizedDescription))
            }
        }
        
        if let nsError = error as NSError?, nsError.domain == kGIDSignInErrorDomain {
            return .apiError(.authenticationFailed(error.localizedDescription))
        }
        
        return .apiError(.unknown(error.localizedDescription))
    }
}
