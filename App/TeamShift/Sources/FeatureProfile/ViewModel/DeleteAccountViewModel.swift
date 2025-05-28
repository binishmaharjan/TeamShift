import ClientApi
import ClientAuthentication // TODO: UserSession
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
    
    private var userSession: UserSession { .shared }
    
    var password: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var isDeleteButtonEnabled: Bool {
        (signInMethod == .email) ? (password.count > 5) : true
    }
    var signInMethod: SignInMethod {
        userSession.appUser?.signInMethod ?? .guest
    }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    
    func deleteButtonTapped() async {
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
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension DeleteAccountViewModel {
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
