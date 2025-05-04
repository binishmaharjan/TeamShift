import Foundation

public struct AppUser: Equatable, Identifiable, Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case isAnonymous = "is_anonymous"
    }
    
    public init(id: String, username: String?, email: String?, isAnonymous: Bool) {
        self.id = id
        self.username = username
        self.email = email
        self.isAnonymous = isAnonymous
    }
    
    public let id: String
    public let username: String?
    public let email: String?
    public let isAnonymous: Bool
}
