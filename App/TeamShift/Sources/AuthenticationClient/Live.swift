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
            reAuthenticate: { try await session.reAuthenticate(withEmail: $0, password: $1) },
            reAuthenticateWithGoogle: { try await session.reAuthenticateWithGoogle() },
            sendPasswordReset: { try await session.sendPasswordReset(withEmail: $0) },
            linkAccount: { try await session.linkAccount(withEmail: $0, password: $1) },
            linkAccountWithGmail: { try await session.linkAccountWithGmail() },
            changePassword: { try await session.updatePassword(to: $0, oldPassword: $1) },
            deleteUser: { try await session.deleteUser() },
            signOut: { try await session.signOut() }
        )
    }
}

extension AuthenticationClient {
    actor Session {
        @Dependency(\.randomIDHelper) private var randomIDHelper
        
        func createUser(withEmail email: String, password: String) async throws -> AppUser {
            do {
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                
                let changeRequest = authDataResult.user.createProfileChangeRequest()
                changeRequest.displayName = email.toName
                try await changeRequest.commitChanges()
                
                return createNewUser(
                    id: authDataResult.user.uid,
                    username: authDataResult.user.displayName,
                    email: authDataResult.user.email,
                    signInMethod: .email
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
                changeRequest.displayName = "user_\(randomIDHelper.generate(length: 10))"
                try await changeRequest.commitChanges()
                
                return createNewUser(
                    id: authDataResult.user.uid,
                    username: authDataResult.user.displayName,
                    email: authDataResult.user.email,
                    signInMethod: .guest
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
                
                return createNewUser(
                    id: authDataResult.user.uid,
                    username: authDataResult.user.displayName,
                    email: authDataResult.user.email,
                    signInMethod: .google
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
        
        func reAuthenticate(withEmail email: String, password: String) async throws {
            do {
                guard let currentUser = Auth.auth().currentUser else {
                    throw AppError.internalError(.userNotFound)
                }
                
                let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
                
                _ = try await currentUser.reauthenticate(with: credentials)
            } catch {
                throw mapError(error)
            }
        }
        
        func reAuthenticateWithGoogle() async throws {
            do {
                guard let currentUser = Auth.auth().currentUser else {
                    throw AppError.internalError(.userNotFound)
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
                _ = try await currentUser.reauthenticate(with: credentials)
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
                guard let currentUser = Auth.auth().currentUser else {
                    throw AppError.internalError(.userNotFound)
                }
                
                guard let email = currentUser.email else {
                    throw AppError.internalError(.invalidUserData)
                }
                
                try await reAuthenticate(withEmail: email, password: oldPassword)

                try await currentUser.updatePassword(to: newPassword)
            } catch {
                throw mapError(error)
            }
        }
        
        func deleteUser() async throws {
            let currentUser = Auth.auth().currentUser
            try await currentUser?.delete()
        }

        func signOut() async throws {
            do {
                try Auth.auth().signOut()
            } catch {
                throw mapError(error)
            }
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
        
        private func createNewUser(id: String, username: String?, email: String?, signInMethod: SignInMethod) -> AppUser {
            let randomColorTemplate = ColorTemplate(rawValue: generateRandomNumber(upTo: ColorTemplate.allCases.count)) ?? .redOrange
            let randomIconData = IconData(rawValue: generateRandomNumber(upTo: IconData.allCases.count)) ?? .icnMan2
            return AppUser(
                id: id,
                username: username,
                email: email,
                signInMethod: signInMethod,
                avatar: Avatar(colorTemplate: randomColorTemplate, iconData: randomIconData),
                fcmToken: "random_token",
                subscription: Subscription(status: .free),
                createdDate: .now
            )
        }
        
        private func generateRandomNumber(upTo number: Int) -> Int {
            Int.random(in: 0 ..< number )
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
                
            case .wrongPassword, .invalidCredential:
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
