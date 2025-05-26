import ClientAuthentication
import ClientUserStore
import Dependencies
import Foundation
import Observation
import SharedModels
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
    
    // User Data
    private var userSession: UserSession { .shared }
    var user: AppUser? { userSession.appUser }
    var displayUid: String { userSession.displayUid ?? "" }
    var username: String { user?.username ?? "" }
    var toastHandler: ToastHandler = .init()
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.authenticationClient) private var authenticationClient
    @ObservationIgnored
    @Dependency(\.userStoreClient) var userStoreClient
    @ObservationIgnored
    private let pasteboard = UIPasteboard.general
    
    func signOutButtonTapped() async {
        await showSignOutConfirm()
    }
    
    func copyUserIDButtonTapped() {
        pasteboard.string = displayUid
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
    
    private func updateUsername(to newUsername: String?) async {
        guard let user = userSession.appUser, let newUsername else {
            // TODO: Error Handling
            return
        }
        
        isLoading = true
        do {
            let dict = SendableDictionary(user.dictionaryBuilder().username(newUsername).dictionary)
            try await userStoreClient.updateUser(user.id, dict)
            
            // update saved user session
            userSession.appUser?.username = newUsername
            
            isLoading = false
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

// MARK: Alert
extension ProfileViewModel {
    private func showSignOutConfirm() async {
        alertConfig = .confirm(
            buttonTitle: l10.commonButtonOK,
            title: l10.profileAlertSignOutTitle,
            message: l10.profileAlertSignOutDescription,
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
            title: l10.profileAlertChangeUsernameTitle,
            message: l10.profileAlertChangeUsernameDescription,
            textHint: l10.profileAlertChangeUsernameHint,
            primaryAction: { [weak self] newUsername in
                Task { @MainActor in
                    self?.alertConfig = nil
                    await self?.updateUsername(to: newUsername)
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
