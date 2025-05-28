import ClientApi
import ClientUserSession
import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class ChangePasswordViewModel {
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
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    @ObservationIgnored
    @Dependency(\.userSession) var userSession
    
    func changePasswordButtonTapped() async {
        guard let currentUser = userSession.currentUser else {
            showErrorAlert(AppError.internalError(.userNotFound))
            return
        }
        
        guard userSession.isSignInMethod(.email) else {
            showErrorAlert(AppError.internalError(.invalidUserData))
            return
        }
        
        guard newPassword == confirmPassword else {
            showErrorAlert(AppError.internalError(.passwordNotMatched))
            return
        }
        
        isLoading = true
        do {
            try await apiClient.changePassword(to: newPassword, oldPassword: oldPassword)
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
