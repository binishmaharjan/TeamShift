import ApiClient
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
    @ObservationIgnored
    weak var coordinator: AuthenticationCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    
    var email = ""
    var password = ""
    var isLoading = false
    
    var isCreateButtonEnabled: Bool {
        email.isEmail && password.count > 5
    }
    
    // MARK: Methods
    func createButtonTapped() async {
        isLoading = true
        do {
            try await apiClient.createUser(withEmail: email, password: password)
            
            isLoading = false
            coordinator?.finish(with: .showMainTab)
        } catch {
            isLoading = false
            handleError(error)
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
            handleError(error)
        }
    }
}

extension CreateAccountViewModel {
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
