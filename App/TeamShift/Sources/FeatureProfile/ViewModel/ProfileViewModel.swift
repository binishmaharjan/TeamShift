import ClientAuthentication
import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class ProfileViewModel {
    enum Route {
        case showOnboarding
    }
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var sections: [ProfileSection] = ProfileSection.allCases
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.authenticationClient) private var authenticationClient
    
    func signOutButtonTapped() async {
        await showSignOutConfirm()
    }
}

// MARK: Private Method
extension ProfileViewModel {
    private func signOut() async {
        do {
            try await authenticationClient.signOut()
            coordinator?.profileRequestNavigation(for: .showOnboarding)
        } catch {
            showErrorAlert(error)
        }
    }
}

// MARK: Alert
extension ProfileViewModel {
    private func showSignOutConfirm() async {
        alertConfig = .confirm(
            buttonTitle: l10.commonButtonOK,
            title: "Sign out",
            message: "You will need to sign in again to access your account. If you are guest user all data will be lost.",
            primaryAction: { [weak self] in
                Task { @MainActor in
                    self?.alertConfig = nil
                    await self?.signOut()
                }
            },
            secondaryAction: { [weak self] in
                Task { @MainActor in self?.alertConfig = nil }
            }
        )
    }
    
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
