import ClientAuthentication
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class OnboardingViewModel {
    enum Route {
        case createAccount
        case login
    }
    
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    var didRequestNavigation: ((Route) -> Void)?
    var alertConfig: AlertDialog.Config?
    
    func createAccountButtonTapped() {
        didRequestNavigation?(.createAccount)
    }
    
    func loginButtonTapped() {
        didRequestNavigation?(.login)
    }
    
    func signUpAsGuestTapped() async {
        alertConfig = .confirm(
            buttonTitle: "Continue as Guest",
            title: "Continue as Guest?",
            message: "You'll get immediate access to view team schedules without creating an account. Your data won't be saved between sessions and some features may be limited.",
            primaryAction: { [weak self] _ in
                Task { @MainActor in self?.handleContinueAsGuestAction() }
            },
            secondaryAction: { [weak self] _ in
                Task { @MainActor in self?.alertConfig = nil }
            }
        )
    }
    
    private func handleContinueAsGuestAction() {
        print("Handle this action")
        alertConfig = nil
    }
}
