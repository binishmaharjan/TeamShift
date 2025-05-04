import Dependencies
import FirebaseFirestore
import Foundation
import SharedModels

// MARK: Dependency (liveValue)
extension UserStoreClient: DependencyKey {
    public static let liveValue = UserStoreClient.live()
}

extension UserStoreClient {
    public static func live() -> UserStoreClient {
        let session = Session()
        
        return UserStoreClient(
            saveUser: { try await session.saveUserToStore(withUser: $0) },
            getUser: { try await session.getUserFromStore(for: $0) }
        )
    }
}

extension UserStoreClient {
    actor Session {
        func saveUserToStore(withUser user: AppUser) async throws {
            do {
                let reference = Firestore.firestore().collection(Collection.users.rawValue).document(user.id)
                try reference.setData(from: user)
            } catch {
                throw UserStoreError(from: error)
            }
        }
        
        func getUserFromStore(for uid: String) async throws -> AppUser {
            do {
                let reference = Firestore.firestore().collection(Collection.users.rawValue).document(uid)
                let user = try await reference.getDocument(as: AppUser.self)
                return user
            } catch {
                throw UserStoreError(from: error)
            }
        }
    }
}
