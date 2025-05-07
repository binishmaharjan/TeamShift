import FirebaseAuth
import Foundation
import GoogleSignIn
import GoogleSignInSwift

enum AuthError: Error, LocalizedError, Equatable {
    case auth(message: String)
    case gid(message: String)
    case networkError
    case unknown(errorCode: Int, message: String)

    // Initializer to map from a Firebase Error
    init(from firebaseError: Error) {
        // Try to cast to NSError to check domain and code
        if let nsError = firebaseError as NSError?, nsError.domain == AuthErrorDomain {
            guard let code = AuthErrorCode(rawValue: nsError.code) else {
                self = .unknown(errorCode: nsError.code, message: firebaseError.localizedDescription)
                return
            }
            
            switch code {
            case .networkError:
                self = .networkError
                
            default:
                self = .auth(message: firebaseError.localizedDescription)
            }
        } else if let nsError = firebaseError as NSError?, nsError.domain == kGIDSignInErrorDomain {
            self = .gid(message: firebaseError.localizedDescription)
        } else {
            self = .unknown(errorCode: -1, message: "Unknown Error")
        }
    }
  
    public var errorDescription: String? {
        switch self {
        case .auth(let message):
            return message
            
        case .gid(let message):
            return message
            
        case .networkError:
            return "Network error. Please check your connection and try again."
            
        case .unknown(_, let message):
             return "An unknown error occurred: \(message)"
        }
    }
}
