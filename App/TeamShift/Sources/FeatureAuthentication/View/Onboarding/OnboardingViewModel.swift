import ClientApi
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
    @Dependency(\.apiClient) var apiClient
    
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
                Task {
                    await self?.handleContinueAsGuestAction()
                }
            },
            secondaryAction: { [weak self] in
                self?.alertConfig = nil
            }
        )
    }
    
    private func handleContinueAsGuestAction() async {
        alertConfig = nil
        
        isLoading = true
        do {
            try await apiClient.signUpAsGuest()
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
            self?.alertConfig = nil
        }
    }
}
