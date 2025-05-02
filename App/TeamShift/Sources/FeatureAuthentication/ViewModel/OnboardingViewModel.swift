import Foundation
import Observation

@Observable @MainActor
final class OnboardingViewModel {
    enum Route {
        case createAccount
        case login
    }
    
    var didRequestNavigation: ((Route) -> Void)?
    
    func createAccountButtonTapped() {
        didRequestNavigation?(.createAccount)
    }
    
    func loginButtonTapped() {
        didRequestNavigation?(.login)
    }
}
