import FirebaseAuth
import Foundation
import Observation

@Observable @MainActor
final class MainTabViewModel {
    // MARK: Properties
    var didRequestFinish: ((MainTabResult) -> Void)?
    
    func doneButtonTapped() {
        do {
            try Auth.auth().signOut()
            didRequestFinish?(.showAuthentication)
        } catch {
            print("Error Sign Out")
        }
    }
}
