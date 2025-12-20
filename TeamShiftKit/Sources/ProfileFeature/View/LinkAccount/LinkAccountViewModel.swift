import ApiClient
import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class LinkAccountViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    @ObservationIgnored
    @Dependency(\.userSession) var userSession
    
    var email: String = ""
    var password: String = ""
    var isLoading = false
    var isSignInButtonEnabled: Bool {
        email.isEmail && password.count > 5
    }
    
    func linkButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.linkAccount(withEmail: email, password: password)
            
            // update saved user session
            userSession.currentUser?.email = email
            userSession.currentUser?.signInMethod = .email
            
            isLoading = false
            linkSuccess()
        } catch {
            isLoading = false
            handleError(error)
        }
    }
    
    func linkWithGoogleButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.linkAccountWithGmail()
            
            // update saved user session
            userSession.currentUser?.signInMethod = .google
            
            isLoading = false
            linkSuccess()
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

extension LinkAccountViewModel {
    private func linkSuccess() {
        coordinator?.showSuccessAlert(message: l10.changePasswordAlertChangeSuccess) { [weak self] in
            self?.email = ""
            self?.password = ""
        }
    }
    
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
