import ClientAuthentication
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
    @Dependency(\.authenticationClient) var authenticationClient
    
    func signInButtonTapped() async {
        isLoading = true
        do {
            _ = try await authenticationClient.signIn(withEmail: email, password: password)
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
            _ = try await authenticationClient.signInWithGoogle()
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
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
