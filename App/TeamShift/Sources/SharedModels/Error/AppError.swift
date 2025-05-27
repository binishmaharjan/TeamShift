import Foundation

public enum ApiError: LocalizedError, Equatable {
    case authenticationFailed(String)
    case userNotFound
    case invalidCredentials
    case networkTimeout
    case emailAlreadyInUse
    
    case dataNotFound
    case permissionDenied
    case storeTimeout
    case documentCreationFailed
    case documentUpdateFailed
    
    case unknown(String)
    case offline
    case rateLimited
    
    public var errorDescription: String? {
        switch self {
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
            
        case .userNotFound:
            return "User account not found"
            
        case .invalidCredentials:
            return "Invalid email or password"
            
        case .networkTimeout:
            return "Network request timed out"
            
        case .emailAlreadyInUse:
            return "An account with this email already exists"
            
        case .dataNotFound:
            return "Requested data not found"
            
        case .permissionDenied:
            return "You don't have permission to access this data"
            
        case .storeTimeout:
            return "Database request timed out"
            
        case .documentCreationFailed:
            return "Failed to create document"
            
        case .documentUpdateFailed:
            return "Failed to update document"
            
        case .unknown(let message):
            return "An unexpected error occurred: \(message)"
            
        case .offline:
            return "No internet connection available"
            
        case .rateLimited:
            return "Too many requests. Please try again later"
        }
    }
}

public enum InternalError: LocalizedError, Equatable {
    case userNotFound
    case invalidUserData
    
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User data not found"
        
        case .invalidUserData:
            return "Invalid User data"
        }
    }
}

public enum AppError: LocalizedError, Equatable {
    case apiError(ApiError)
    case internalError(InternalError)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .apiError(let apiError):
            return apiError.localizedDescription
            
        case .internalError(let internalError):
            return internalError.localizedDescription
            
        case .unknown:
            return "Unknown Error"
        }
    }
}
