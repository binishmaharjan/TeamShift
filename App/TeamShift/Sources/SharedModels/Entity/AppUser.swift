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

@DictionaryBuilder
public struct Subscription: Equatable, Codable, Sendable {
    public enum Status: Int, Equatable, Codable, Sendable {
        case free = 0
        case paid = 1
    }
    
    public init(status: Status, expiryDate: Date? = nil) {
        self.status = status
        self.expiryDate = expiryDate
    }
    
    var status: Status
    var expiryDate: Date?
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
        case fcmToken = "fcm_token"
        case subscription
        case createdDate = "created_date"
        case workplaceIds = "workplace_ids"
    }
    
    public init(
        id: String,
        username: String?,
        email: String?,
        signInMethod: SignInMethod,
        avatar: Avatar,
        fcmToken: String,
        subscription: Subscription,
        createdDate: Date,
        workplaceIds: [String] = []
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.signInMethod = signInMethod
        self.avatar = avatar
        self.fcmToken = fcmToken
        self.subscription = subscription
        self.createdDate = createdDate
        self.workplaceIds = workplaceIds
    }
    
    public let id: String
    public var username: String?
    public var email: String?
    public var signInMethod: SignInMethod
    public var avatar: Avatar
    public var fcmToken: String
    public var subscription: Subscription
    public var createdDate: Date
    public var workplaceIds: [String]
}
