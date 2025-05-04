import Foundation

public struct AppUser: Equatable, Identifiable, Codable {
    public let id: String
    public let username: String
    public let email: String
    public let isAnonymous: Bool
    public let isEmailVerified: Bool
    
}
