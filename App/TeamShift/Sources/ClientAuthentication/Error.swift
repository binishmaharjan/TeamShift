import FirebaseAuth
import Foundation

enum AuthError: Error, LocalizedError, Equatable {
    case auth(message: String)
    case networkError
    case unknown(errorCode: Int, message: String)

    // Initializer to map from a Firebase Error
    init(from firebaseError: Error) {
        // Try to cast to NSError to check domain and code
        guard let nsError = firebaseError as NSError?, nsError.domain == AuthErrorDomain else {
            self = .unknown(errorCode: (firebaseError as NSError?)?.code ?? 0, message: firebaseError.localizedDescription)
            return
        }
        
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
    }
    
    public var errorDescription: String? {
        switch self {
        case .auth(message: let message):
            return message
            
        case .networkError:
            return "Network error. Please check your connection and try again."
            
        case .unknown(_, let message):
             return "An unknown error occurred: \(message)"
        }
    }
}
