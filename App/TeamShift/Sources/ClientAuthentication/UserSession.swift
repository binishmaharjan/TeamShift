import FirebaseAuth
import Foundation

public final class UserSession: Sendable {
    private init() { }
    
    public static let shared = UserSession()
    
    public var uid: String? {
        Auth.auth().currentUser?.uid
    }
    
    public var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
}
