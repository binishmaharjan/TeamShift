import ClientAuthentication
import Dependencies
import Foundation
import Observation

@Observable @MainActor
final class OnboardingViewModel {
    enum Route {
        case createAccount
        case login
    }
    
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    var didRequestNavigation: ((Route) -> Void)?
    
    func createAccountButtonTapped() {
        didRequestNavigation?(.createAccount)
    }
    
    func loginButtonTapped() {
        didRequestNavigation?(.login)
    }
    
    func signUpAsGuestTapped() async {
    }
}
