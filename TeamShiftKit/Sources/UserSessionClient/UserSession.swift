import Dependencies
import FirebaseAuth
import Foundation
import SharedModels

@MainActor
public class UserSession {
    // MARK: Properties - Auth
   var currentAuthUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    public var isLoggedIn: Bool {
        currentAuthUser != nil
    }
    
    // MARK: Properties - App User
    public var currentUser: AppUser?
    public var uid: String? {
        currentAuthUser?.uid
    }
    public var displayID: String? {
        let uid = uid ?? ""
        return String(uid.prefix(16))
    }
    public var userName: String? {
        currentUser?.username
    }
}

// MARK: Functions
extension UserSession {
    public func isSignInMethod(_ method: SignInMethod) -> Bool {
        guard let currentAuthUser else {
            return false
        }
        
        if method == .guest {
            return currentAuthUser.isAnonymous
        }
        
        let providerIDs = currentAuthUser.providerData.map(\.providerID)
        return providerIDs.contains(method.providerID)
    }
}

// MARK: DependencyValues
extension DependencyValues {
    public var userSession: UserSession {
        get { self[UserSession.self] }
        set { self[UserSession.self] = newValue }
    }
}

// MARK: Instances
extension UserSession {
    static var mock = UserSession()
    static var live = UserSession()
}

extension UserSession: @preconcurrency TestDependencyKey {
    public static let testValue: UserSession = .mock
}

extension UserSession: @preconcurrency DependencyKey {
    public static let liveValue: UserSession = .live
}
