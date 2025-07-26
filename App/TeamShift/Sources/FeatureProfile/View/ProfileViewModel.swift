import ClientApi
import ClientUserSession
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
        case showChangeAvatar
        case showChangePassword
        case showLinkAccount
        case showDeleteAccount
        case showStartWeekday
        case showLicense
    }
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        self.user = userSession.currentUser
        self.displayUid = userSession.displayID ?? ""
    }
    
    // MARK: Properties
    var isLoading = false
    var sections: [ProfileSection] = ProfileSection.allCases
    
    // User Data
    var user: AppUser?
    var displayUid: String = ""
    var username: String { user?.username ?? "" }
    var colorTemplate: ColorTemplate { user?.avatar.colorTemplate ?? .redOrange }
    var iconData: IconData { user?.avatar.iconData ?? .icnMan2 }
    var toastHandler: ToastHandler = .init()
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.userSession) private var userSession
    @ObservationIgnored
    @Dependency(\.apiClient) private var apiClient
    private let pasteboard = UIPasteboard.general
    
    func signOutButtonTapped() async {
        await showSignOutConfirm()
    }
    
    func copyUserIDButtonTapped() {
        pasteboard.string = displayUid
        toastHandler.queueMessage("Copied")
    }
    
    func refreshUserData() {
        user = userSession.currentUser
    }
    
    func listRowTapped(_ listRow: ProfileRow) {
        switch listRow {
        case .changeAvatar:
            coordinator?.profileRequestNavigation(for: .showChangeAvatar)
            
        case .changeUsername:
            showEditNameAlert()
            
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
            try await apiClient.signOut()
            coordinator?.profileRequestNavigation(for: .showOnboarding)
        } catch {
            handleError(error)
        }
    }
    
    private func updateUsername(to newUsername: String?) async {
        guard let currentUser = userSession.currentUser else {
            handleError(AppError.internalError(.userNotFound))
            return
        }
        
        guard let newUsername, !newUsername.isEmpty else {
            return
        }
        
        isLoading = true
        do {
            let dict = currentUser.dictionaryBuilder()
                .username(newUsername)
                .dictionary.asSendable
            try await apiClient.updateUser(uid: currentUser.id, fields: dict)
            
            // update saved user session
            userSession.currentUser?.username = newUsername
            refreshUserData()
            
            isLoading = false
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

// MARK: Alert
extension ProfileViewModel {
    private func showSignOutConfirm() async {
        coordinator?.signOutConfirmDialog {[weak self] in
            Task {
                await self?.signOut()
            }
        }
    }
    
    private func showEditNameAlert() {
        coordinator?.editNameDialog { [weak self] newUsername in
            Task {
                await self?.updateUsername(to: newUsername)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
