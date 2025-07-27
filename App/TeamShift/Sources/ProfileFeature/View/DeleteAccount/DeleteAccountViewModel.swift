import ApiClient
import UserSessionClient
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
            handleError(error)
        }
    }
}

extension DeleteAccountViewModel {
    private func confirmDeletion() {
        coordinator?.deleteConfirmDialog { [weak self] in
            Task {
                await self?.deleteAccount()
            }
        }
    }
    
    private func successAccountDeleted() {
        coordinator?.showSuccessAlert(
            title: l10.deleteAccountAlertSuccessTitle,
            message: l10.deleteAccountAlertSuccessMessage
        ) { [weak self] in
            self?.coordinator?.finish(with: .showOnboarding)
        }
    }
    
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
