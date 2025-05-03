import Foundation
import Observation

@Observable @MainActor
final class SignInViewModel {
    // MARK: Properties
    var didRequestFinish: ((AuthenticationResult) -> Void)?
    
    func loginButtonTapped() {
        didRequestFinish?(.showMainTab)
    }
}
