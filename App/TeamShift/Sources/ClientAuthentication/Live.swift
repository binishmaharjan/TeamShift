import Dependencies
@preconcurrency import FirebaseAuth
import Foundation

// MARK: Dependency (liveValue)
extension AuthenticationClient: DependencyKey {
    public static let liveValue = AuthenticationClient.live()
}

extension AuthenticationClient {
    public static func live() -> AuthenticationClient {
        let session = Session()
        
        return AuthenticationClient(
            createUser: { try await session.createUser(withEmail: $0, password: $1) },
            signIn: {try await session.signIn(with: $0, password: $1) }
            // swiftlint:disable:previous closure_spacing
        )
    }
}

extension AuthenticationClient {
    actor Session {
        func createUser(withEmail: String, password: String) async throws -> String {
            do {
                let authDataResult = try await Auth.auth().createUser(withEmail: withEmail, password: password)
                
                let changeRequest = authDataResult.user.createProfileChangeRequest()
                let tempUsername = String(withEmail.split(separator: "@").first ?? "")
                changeRequest.displayName = tempUsername
                
                try await changeRequest.commitChanges()
                
                return authDataResult.user.uid
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
    }
}
