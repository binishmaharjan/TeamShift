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
            changePassword: { try await session.updatePassword(to: $0) },
            deleteUserWithReauthentication: { try await session.deleteUserWithReauthentication(withEmail: $0, password: $1) },
            deleteUserWithGoogleReauthentication: { try await session.deleteUserWithGoogleReauthentication() },
            signOut: { try await session.signout() }
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
                throw AuthError(from: error)
            }
        }
        
        func signIn(with email: String, password: String) async throws -> String {
            do {
                let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
                return authDataResult.user.uid
            } catch {
                throw AuthError(from: error)
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
                throw AuthError(from: error)
            }
        }
        
        func signUpWithGoogle() async throws -> AppUser {
            do {
                let gidGoogleUser = try await oAuthGoogleSignIn()
                
                guard let idToken = gidGoogleUser.idToken else {
                    throw AuthError.gid(message: "ID Token Missing")
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
                throw AuthError(from: error)
            }
        }
        
        func signInWithGoogle() async throws -> String {
            do {
                let gidGoogleUser = try await oAuthGoogleSignIn()
                guard let idToken = gidGoogleUser.idToken else {
                    throw AuthError.gid(message: "Failed to get Google authentication token")
                }
                
                let accessToken = gidGoogleUser.accessToken
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                
                let authDataResult = try await Auth.auth().signIn(with: credentials)
                return authDataResult.user.uid
            } catch {
                throw AuthError(from: error)
            }
        }
        
        func sendPasswordReset(withEmail email: String) async throws {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
            } catch {
                throw AuthError(from: error)
            }
        }
        
        func linkAccount(withEmail email: String, password: String) async throws {
            do {
                guard let currentUser = Auth.auth().currentUser, currentUser.isAnonymous else {
                    throw AuthError.auth(message: "User is not anonymous")
                }
                
                let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
                
                _ = try await currentUser.link(with: credentials)
            } catch {
                throw AuthError(from: error)
            }
        }
        
        func linkAccountWithGmail() async throws {
            do {
                guard let currentUser = Auth.auth().currentUser, currentUser.isAnonymous else {
                    throw AuthError.auth(message: "User is not anonymous")
                }
                
                let gidGoogleUser = try await oAuthGoogleSignIn()
                guard let idToken = gidGoogleUser.idToken else {
                    throw AuthError.gid(message: "Failed to get Google authentication token")
                }
                
                let accessToken = gidGoogleUser.accessToken
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                
                _ = try await currentUser.link(with: credentials)
            } catch {
               throw  AuthError(from: error)
            }
        }
        
        func updatePassword(to newPassword: String) async throws {
            do {
                let currentUser = Auth.auth().currentUser
                try await currentUser?.updatePassword(to: newPassword)
            } catch {
                throw  AuthError(from: error)
            }
        }
        
        func deleteUserWithReauthentication(withEmail email: String, password: String) async throws {
            do {
                let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
                let isReauthenticated = try await reauthenticate(with: credentials)
                
                guard isReauthenticated else {
                    throw AuthError.auth(message: "Failed to Reauthenticate")
                }
                
                try await deleteUser()
            } catch {
                throw  AuthError(from: error)
            }
        }
        
        func deleteUserWithGoogleReauthentication() async throws {
            do {
                let gidGoogleUser = try await oAuthGoogleSignIn()
                guard let idToken = gidGoogleUser.idToken else {
                    throw AuthError.gid(message: "Failed to get Google authentication token")
                }
                
                let accessToken = gidGoogleUser.accessToken
                let credentials = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                let isReauthenticated = try await reauthenticate(with: credentials)
                
                guard isReauthenticated else {
                    throw AuthError.auth(message: "Failed to Reauthenticate")
                }
                
                try await deleteUser()
            } catch {
                throw  AuthError(from: error)
            }
        }
        
        func signout() async throws {
            do {
                try Auth.auth().signOut()
            } catch {
                throw AuthError(from: error)
            }
        }
        
        // func reauthenticate
        private func reauthenticate(with credentials: AuthCredential) async throws -> Bool {
            let currentUser = Auth.auth().currentUser
            let authResult = try await currentUser?.reauthenticate(with: credentials)
            return authResult?.user != nil
        }
        
        private func deleteUser() async throws {
            let currentUser = Auth.auth().currentUser
            try await currentUser?.delete()
        }
        
        @MainActor
        private func oAuthGoogleSignIn() async throws -> GIDGoogleUser {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AuthError.gid(message: "Google Sign In not configured")
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                throw AuthError.gid(message: "Failed to get Root")
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
