import ClientAuthentication
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class ForgotPasswordViewModel {
    var email: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var isEmailValid: Bool { email.isEmail }
    
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    
    func sendEmailButtonTapped() async {
        isLoading = true
        do {
            try await authenticationClient.sendPasswordReset(withEmail: email)
            isLoading = false
            showEmailSentAlert()
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension ForgotPasswordViewModel {
    private func showEmailSentAlert() {
        alertConfig = .success(message: l10.forgotPasswordAlertSentTitle) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
