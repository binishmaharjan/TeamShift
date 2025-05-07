import Foundation

public enum SignInMethod: String, Codable, Sendable {
    case email
    case google
    case apple
    case guest
}

public struct AppUser: Equatable, Identifiable, Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case signInMethod = "sign_in_method"
        case createdDate = "created_date"
    }
    
    public init(id: String, username: String?, email: String?, signInMethod: SignInMethod, createdDate: Date) {
        self.id = id
        self.username = username
        self.email = email
        self.signInMethod = signInMethod
        self.createdDate = createdDate
    }
    
    public let id: String
    public let username: String?
    public let email: String?
    public let signInMethod: SignInMethod
    public let createdDate: Date
}
