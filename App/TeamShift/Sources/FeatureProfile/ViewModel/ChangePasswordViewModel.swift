import ClientAuthentication
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class ChangePasswordViewModel {
    enum PasswordError: Error, LocalizedError {
        case passwordNotMatched
        
        var errorDescription: String? {
            switch self {
            case .passwordNotMatched:
                return "The passwords you entered don't match"
            }
        }
    }
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    var oldPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var isChangePasswordButtonEnabled: Bool {
        oldPassword.count > 5 && newPassword.count > 5 && confirmPassword.count > 5
    }
    
    private var userSession: UserSession { .shared }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    
    func changePasswordButtonTapped() async {
        guard let currentUser = userSession.appUser, userSession.isSignInMethod(.email), newPassword == confirmPassword else {
            showErrorAlert(PasswordError.passwordNotMatched)
            return
        }
        isLoading = true
        
        do {
            try await authenticationClient.changePassword(to: newPassword, oldPassword: oldPassword)
            isLoading = false
            passwordChangedSuccess()
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension ChangePasswordViewModel {
    private func passwordChangedSuccess() {
        alertConfig = .success(message: l10.changePasswordAlertChangeSuccess) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
                self?.oldPassword = ""
                self?.newPassword = ""
                self?.confirmPassword = ""
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
