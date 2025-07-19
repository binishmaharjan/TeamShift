import ClientApi
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class SignInViewModel {
    enum Route {
        case forgotPassword
    }
    
    init(coordinator: AuthenticationCoordinator) {
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
    weak var coordinator: AuthenticationCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    
    func signInButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.signIn(withEmail: email, password: password)
            
            isLoading = false
            coordinator?.finish(with: .showMainTab)
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
    
    func signInWithGoogleButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.signInWithGoogle()
            
            isLoading = false
            coordinator?.finish(with: .showMainTab)
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
    
    func forgotPasswordButtonTapped() {
        coordinator?.signInRequestNavigation(for: .forgotPassword)
    }
}

extension SignInViewModel {
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            self?.alertConfig = nil
        }
    }
}
