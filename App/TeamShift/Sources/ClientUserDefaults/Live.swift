import Dependencies
import Foundation
import SharedModels

private enum Keys {
    static let appUser = "com.teamshift.app_user"
}

extension UserDefaultsClient: DependencyKey {
    public static let liveValue = UserDefaultsClient.live()
}

// MARK: - Live Implementation
extension UserDefaultsClient {
    // UserDefaults wrapper to make it sendable
    struct SendableUserDefaults: @unchecked Sendable {
        private let userDefaults = UserDefaults.standard
        
        func data(forKey key: String) -> Data? {
            userDefaults.data(forKey: key)
        }
        
        func set(_ data: Data?, forKey key: String) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    public static func live() -> UserDefaultsClient {
        let userDefaults = SendableUserDefaults()
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        
        return UserDefaultsClient(
            appUser: { [userDefaults] in
                guard let data = userDefaults.data(forKey: Keys.appUser) else {
                    print("❌ UserDefaultsClient: appUser not found")
                    return .none
                }
                
                guard let appUser = try? jsonDecoder.decode(AppUser.self, from: data) else {
                    print("❌ UserDefaultsClient: failed to decode appUser")
                    return .none
                }
                
                return appUser
            },
            setAppUser: { newAppUser in
                guard let data = try? jsonEncoder.encode(newAppUser) else {
                    print("❌ UserDefaultsClient: failed to encode appUser")
                    return
                }
                
                userDefaults.set(data, forKey: Keys.appUser)
            }
        )
    }
}
