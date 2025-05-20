import ClientAuthentication
import Dependencies
import Foundation
import Observation
import SharedUIs
import UIKit

@Observable @MainActor
final class ProfileViewModel {
    enum Route {
        case showOnboarding
        case showChangePassword
        case showLinkAccount
        case showDeleteAccount
        case showStartWeekday
        case showLicense
    }
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var sections: [ProfileSection] = ProfileSection.allCases
    var uid: String { UserSession.shared.uid ?? "" }
    var userName: String { UserSession.shared.userName ?? "" }
    var toastHandler: ToastHandler = .init()
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.authenticationClient) private var authenticationClient
    @ObservationIgnored
    private let pasteboard = UIPasteboard.general
    
    func signOutButtonTapped() async {
        await showSignOutConfirm()
    }
    
    func copyUserIDButtonTapped() {
        pasteboard.string = uid
        toastHandler.queueMessage("Copied")
    }
    
    func editNameButtonTapped() {
        showEditNameAlert()
    }
    
    func listRowTapped(_ listRow: ProfileRow) {
        switch listRow {
        case .changePassword:
            coordinator?.profileRequestNavigation(for: .showChangePassword)
            
        case .linkAccount:
            coordinator?.profileRequestNavigation(for: .showLinkAccount)
            
        case .deleteAccount:
            coordinator?.profileRequestNavigation(for: .showDeleteAccount)
            
        case .startWeekDay:
            coordinator?.profileRequestNavigation(for: .showStartWeekday)
            
        case .showPublicHoliday:
            break // TODO: this is toggle
            
        case .license:
            coordinator?.profileRequestNavigation(for: .showLicense)
        }
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
    
    private func showEditNameAlert() {
        alertConfig = .textField(
            title: "Change Username",
            message: "Please enter new username",
            textHint: "New Username",
            primaryAction: { [weak self] text in
                Task { @MainActor in
                    self?.alertConfig = nil
                    print(text)
                }
            }, secondaryAction: { [weak self] in
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
