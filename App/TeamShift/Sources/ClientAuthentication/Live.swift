import Dependencies
@preconcurrency import FirebaseAuth
import Foundation
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
                    isAnonymous: authDataResult.user.isAnonymous
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
                    isAnonymous: authDataResult.user.isAnonymous
                )
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
        
        private func generateRandomUsername() -> String {
            // the pool of characters to choose
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomCharacters = (0..<10).map { _ -> Character in
                // Select a random character from the allowed set
                // Force unwrap is safe here because 'characters' is guaranteed non-empty
                characters.randomElement()!
            }
            return String(randomCharacters)
        }
    }
}
