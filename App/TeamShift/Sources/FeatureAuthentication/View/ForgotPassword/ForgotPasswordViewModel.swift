import ClientApi
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class ForgotPasswordViewModel {
    init(coordinator: AuthenticationCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    weak var coordinator: AuthenticationCoordinator?
    var email: String = ""
    var isLoading = false
    var isEmailValid: Bool { email.isEmail }
    
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    
    func sendEmailButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.sendPasswordReset(withEmail: email)
            isLoading = false
            showEmailSentAlert()
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

extension ForgotPasswordViewModel {
    private func showEmailSentAlert() {
        email = ""
        coordinator?.showSuccessAlert(message: l10.forgotPasswordAlertSentTitle)
    }
    
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
