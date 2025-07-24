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
        guard newPassword == confirmPassword else {
            handleError(AppError.internalError(.passwordNotMatched))
            return
        }
        
        isLoading = true
        do {
            try await apiClient.changePassword(to: newPassword, oldPassword: oldPassword)
            isLoading = false
            passwordChangedSuccess()
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

extension ChangePasswordViewModel {
    private func passwordChangedSuccess() {
        coordinator?.showSuccessAlert(message: l10.changePasswordAlertChangeSuccess) { [weak self] in
            self?.oldPassword = ""
            self?.newPassword = ""
            self?.confirmPassword = ""
        }
    }
    
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
