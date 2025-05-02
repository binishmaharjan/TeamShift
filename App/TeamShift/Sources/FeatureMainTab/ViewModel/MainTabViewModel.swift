import Foundation
import Observation

@Observable @MainActor
final class MainTabViewModel {
    // MARK: Properties
    var didRequestFinish: ((MainTabResult) -> Void)?
    
    func doneButtonTapped() {
        didRequestFinish?(.showAuthentication)
    }
}
