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
    public static func live() -> UserDefaultsClient {
        let session = Session()
        
        return UserDefaultsClient(
            appUser: { await session.appUser() },
            setAppUser: { await session.setAppUser(newAppUser: $0) }
        )
    }
}

extension UserDefaultsClient {
    actor Session {
        let userDefaults: UserDefaults = .standard
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        
        private func data(forKey key: String) -> Data? {
            userDefaults.data(forKey: key)
        }
        
        private func set(_ data: Data?, forKey key: String) {
            userDefaults.set(data, forKey: key)
        }
        
        func appUser() async -> AppUser? {
            guard let data = data(forKey: Keys.appUser) else {
                print("❌ UserDefaultsClient: appUser not found")
                return .none
            }
            
            guard let appUser = try? jsonDecoder.decode(AppUser.self, from: data) else {
                print("❌ UserDefaultsClient: failed to decode appUser")
                return .none
            }
            
            return appUser
        }
        
        func setAppUser(newAppUser: AppUser?) async {
            guard let data = try? jsonEncoder.encode(newAppUser) else {
                print("❌ UserDefaultsClient: failed to encode appUser")
                return
            }
            
            set(data, forKey: Keys.appUser)
        }
    }
}
