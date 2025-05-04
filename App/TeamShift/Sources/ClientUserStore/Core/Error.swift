import FirebaseFirestore
import Foundation

enum UserStoreError: Error, LocalizedError, Equatable {
    case userStore(message: String)
    case networkError
    case unknown(errorCode: Int, message: String)
    
    init(from firebaseError: Error) {
        guard let nsError = firebaseError as NSError?, nsError.domain == FirestoreErrorDomain else {
            self = .unknown(errorCode: (firebaseError as NSError?)?.code ?? 0, message: firebaseError.localizedDescription)
            return
        }

        guard let code = FirestoreErrorCode.Code(rawValue: nsError.code) else {
            self = .unknown(errorCode: nsError.code, message: firebaseError.localizedDescription)
            return
        }

        switch code {
        case .unavailable, .deadlineExceeded:
            self = .networkError
            
        default:
            self = .userStore(message: firebaseError.localizedDescription)
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .userStore(message: let message):
            return message
            
        case .networkError:
            return "Network error. Please check your connection and try again."
            
        case .unknown(_, let message):
             return "An unknown error occurred: \(message)"
        }
    }
}
