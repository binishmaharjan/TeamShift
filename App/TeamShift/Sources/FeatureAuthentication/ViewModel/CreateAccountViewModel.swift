import Foundation
import Observation

@Observable @MainActor
final class CreateAccountViewModel {
    // MARK: Properties
    var didRequestFinish: ((AuthenticationResult) -> Void)?
    
    func createButtonTapped() {
        didRequestFinish?(.showMainTab)
    }
}
