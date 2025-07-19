import ClientApi
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
    var email: String = ""
    var password: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var isSignInButtonEnabled: Bool {
        email.isEmail && password.count > 5
    }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    @ObservationIgnored
    @Dependency(\.userSession) var userSession
    
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
            showErrorAlert(error)
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
            showErrorAlert(error)
        }
    }
}

extension LinkAccountViewModel {
    private func linkSuccess() {
        alertConfig = .success(message: l10.linkAccountAlertLinkSuccess) { [weak self] in
            self?.alertConfig = nil
            self?.email = ""
            self?.password = ""
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            self?.alertConfig = nil
        }
    }
}
