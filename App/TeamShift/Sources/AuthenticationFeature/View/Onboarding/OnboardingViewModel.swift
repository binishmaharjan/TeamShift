import ApiClient
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
        coordinator?.continueAsGuestConfirmDialog { [weak self] in
            Task {
                await self?.handleContinueAsGuestAction()
            }
        }
    }
    
    private func handleContinueAsGuestAction() async {
        isLoading = true
        do {
            try await apiClient.signUpAsGuest()
            isLoading = false
            coordinator?.finish(with: .showMainTab)
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

extension OnboardingViewModel {
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
