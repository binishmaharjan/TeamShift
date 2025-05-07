import ClientAuthentication
import ClientUserStore
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class CreateAccountViewModel {
    // MARK: Properties
    var didRequestFinish: ((AuthenticationResult) -> Void)?
    var email = ""
    var password = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    
    var isCreateButtonEnabled: Bool {
        email.isEmail && password.count > 5
    }
    
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    @ObservationIgnored
    @Dependency(\.userStoreClient) var userStoreClient
    
    // MARK: Methods
    func createButtonTapped() async {
        isLoading = true
        do {
            let user = try await authenticationClient.createUser(withEmail: email, password: password)
            try await userStoreClient.saveUser(user: user)
            isLoading = false
            didRequestFinish?(.showMainTab)
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
    
    func signUpWithGoogleButtonTapped() async {
        isLoading = true
        do {
            let user = try await authenticationClient.signUpWithGoogle()
            try await userStoreClient.saveUser(user: user)
            isLoading = false
            didRequestFinish?(.showMainTab)
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension CreateAccountViewModel {
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
