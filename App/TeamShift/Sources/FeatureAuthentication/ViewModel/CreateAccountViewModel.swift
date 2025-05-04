import Foundation
import Observation

@Observable @MainActor
final class CreateAccountViewModel {
    // MARK: Properties
    var didRequestFinish: ((AuthenticationResult) -> Void)?
    var email: String = ""
    var password: String = ""
    
    var isCreateButtonEnabled: Bool {
        email.count > 5 && password.count > 5
    }
    
    func createButtonTapped() {
        didRequestFinish?(.showMainTab)
    }
}
