import FirebaseAuth
import Foundation

public final class UserSession: Sendable {
    private init() { }
    
    public static let shared = UserSession()
    
    public var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    public var uid: String? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return String(uid.prefix(16))
    }
    
    public var userName: String? {
        Auth.auth().currentUser?.displayName
    }
}
