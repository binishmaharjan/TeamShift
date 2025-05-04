import Foundation
import Observation

@Observable @MainActor
final class SignInViewModel {
    // MARK: Properties
    var didRequestFinish: ((AuthenticationResult) -> Void)?
    var email: String = ""
    var password: String = ""
    
    func loginButtonTapped() {
        didRequestFinish?(.showMainTab)
    }
}
