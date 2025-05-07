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
                    throw AuthError.gid(message: "ID Token Missing")
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
        
        func signout() async throws {
            do {
                try Auth.auth().signOut()
            } catch {
                throw AuthError(from: error)
            }
        }
        
        private func oAuthGoogleSignIn() async throws -> GIDGoogleUser {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AuthError.gid(message: "Google Client ID Missing")
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = await windowScene.windows.first,
                  let rootViewController = await window.rootViewController else {
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
