import ClientApi
import ClientUserSession
import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class DeleteAccountViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    var password: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var isDeleteButtonEnabled: Bool {
        (signInMethod == .email) ? (password.count > 5) : true
    }
    var signInMethod: SignInMethod {
        userSession.currentUser?.signInMethod ?? .guest
    }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    @ObservationIgnored
    @Dependency(\.userSession) var userSession
    
    func deleteButtonTapped() async {
        confirmDeletion()
    }
    
    private func deleteAccount() async {
        isLoading = true
        do {
            switch signInMethod {
            case .email:
                try await apiClient.deleteUserWithReAuthentication(password: password)
                
            case .google:
                try await apiClient.deleteUserWithGoogleReAuthentication()
                
            case .apple:
                break // TODO: Implement Apple
                
            case .guest:
                try await apiClient.deleteUser()
            }
            
            successAccountDeleted()
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension DeleteAccountViewModel {
    private func confirmDeletion() {
        alertConfig = .confirm(
            buttonTitle: l10.deleteAccountAlertConfirmButtonTitle,
            title: l10.deleteAccountAlertConfirmTitle,
            message: l10.deleteAccountAlertConfirmMessage,
            primaryAction: { [weak self] in
                self?.alertConfig = nil
                Task {
                    await self?.deleteAccount()
                }
            },
            secondaryAction: { [weak self] in
                self?.alertConfig = nil
            }
        )
    }
    
    private func successAccountDeleted() {
        alertConfig = .info(
            title: l10.deleteAccountAlertSuccessTitle,
            message: l10.deleteAccountAlertSuccessMessage
        ) { [weak self] in
            self?.alertConfig = nil
            self?.coordinator?.finish(with: .showOnboarding)
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            self?.alertConfig = nil
        }
    }
}
