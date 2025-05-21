import FirebaseAuth
import Foundation
import SharedModels

public final class UserSession: Sendable {
    // MARK: Init
    private init() { }
    
    // MARK: Shared Instance
    public static let shared = UserSession()
    
    // TODO: Save User Data In UserDefault and access from here?
    
    // MARK: Properties
    private var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    
    public var isLoggedIn: Bool {
        currentUser != nil
    }
    
    public var uid: String? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return String(uid.prefix(16))
    }
    
    public var userName: String? {
        currentUser?.displayName
    }
    
    public var isGuestUser: Bool {
        currentUser?.isAnonymous ?? false
    }
}

// MARK: Functions
extension UserSession {
    public func isSignInMethod(_ method: SignInMethod) -> Bool {
        guard let currentUser else {
            return false
        }
        
        let providerIDs = currentUser.providerData.map(\.providerID)
        return providerIDs.contains(method.providerID)
    }
}
