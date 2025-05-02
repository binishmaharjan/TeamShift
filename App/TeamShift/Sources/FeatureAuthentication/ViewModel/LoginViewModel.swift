import Foundation
import Observation

@Observable @MainActor
final class LoginViewModel {
    // MARK: Properties
    var didRequestFinish: ((AuthenticationResult) -> Void)?
    
    func loginButtonTapped() {
        didRequestFinish?(.showMainTab)
    }
}
