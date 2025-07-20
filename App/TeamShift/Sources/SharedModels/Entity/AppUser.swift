import Foundation

public enum SignInMethod: String, Codable, Sendable {
    case email
    case google
    case apple
    case guest
    
    public var providerID: String {
        switch self {
        case .email:
            return "password"
            
        case .google:
            return "google.com"
            
        case .apple:
            return "apple.com"
            
        case .guest:
            return "none"
        }
    }
}

@DictionaryBuilder
public struct Avatar: Equatable, Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case colorTemplate = "color_template"
        case iconData = "icon_data"
    }
    
    public init(colorTemplate: ColorTemplate, iconData: IconData) {
        self.colorTemplate = colorTemplate
        self.iconData = iconData
    }
    
    public var colorTemplate: ColorTemplate
    public var iconData: IconData
}

/// Represents the app user
@DictionaryBuilder
public struct AppUser: Equatable, Identifiable, Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case signInMethod = "sign_in_method"
        case avatar
        case createdDate = "created_date"
    }
    
    public init(
        id: String,
        username: String?,
        email: String?,
        signInMethod: SignInMethod,
        avatar: Avatar,
        createdDate: Date
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.signInMethod = signInMethod
        self.avatar = avatar
        self.createdDate = createdDate
    }
    
    public let id: String
    public var username: String?
    public var email: String?
    public var signInMethod: SignInMethod
    public var avatar: Avatar
    public var createdDate: Date
}
