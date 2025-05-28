import ClientApi
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class CreateAccountViewModel {
    init(coordinator: AuthenticationCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    weak var coordinator: AuthenticationCoordinator?
    var email = ""
    var password = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    
    var isCreateButtonEnabled: Bool {
        email.isEmail && password.count > 5
    }
    
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    
    // MARK: Methods
    func createButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.createUser(withEmail: email, password: password)
            
            isLoading = false
            coordinator?.finish(with: .showMainTab)
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
    
    func signUpWithGoogleButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.signUpWithGoogle()
            
            isLoading = false
            coordinator?.finish(with: .showMainTab)
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
