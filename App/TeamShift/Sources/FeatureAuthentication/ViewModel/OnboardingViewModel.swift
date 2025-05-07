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
    
    init(coordinator: AuthenticationCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    weak var coordinator: AuthenticationCoordinator?
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    @ObservationIgnored
    @Dependency(\.userStoreClient) var userStoreClient
    
    func createAccountButtonTapped() {
        coordinator?.onboardingRequestNavigation(for: .createAccount)
    }
    
    func loginButtonTapped() {
        coordinator?.onboardingRequestNavigation(for: .login)
    }
    
    func signUpAsGuestTapped() async {
        alertConfig = .confirm(
            buttonTitle: l10.onboardingAlertGuestUserButton,
            title: l10.onboardingAlertGuestUserTitle,
            message: l10.onboardingAlertGuestUserDescription,
            primaryAction: { [weak self] in
                Task { @MainActor in await self?.handleContinueAsGuestAction() }
            },
            secondaryAction: { [weak self] in
                Task { @MainActor in self?.alertConfig = nil }
            }
        )
    }
    
    private func handleContinueAsGuestAction() async {
        alertConfig = nil
        
        isLoading = true
        do {
            let user = try await authenticationClient.signUpAsGuest()
            try await userStoreClient.saveUser(user: user)
            isLoading = false
            coordinator?.finish(with: .showMainTab)
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension OnboardingViewModel {
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
