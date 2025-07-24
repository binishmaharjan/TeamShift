import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class ChangeAvatarViewModel {
    init(coordinator: ProfileCoordinator) {
        @Dependency(\.userSession) var userSession
        
        self.coordinator = coordinator
        // Store original values
        self.originalColorTemplate = userSession.currentUser?.avatar.colorTemplate
        self.originalIconData = userSession.currentUser?.avatar.iconData
        
        // Initialize selected values
        self.selectedColorTemplate = userSession.currentUser?.avatar.colorTemplate
        self.selectedIconData = userSession.currentUser?.avatar.iconData
    }
    
    // MARK: Properties
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    private let originalColorTemplate: ColorTemplate?
    @ObservationIgnored
    private let originalIconData: IconData?
    @ObservationIgnored
    @Dependency(\.userSession) var userSession
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient

    var isLoading = false
    
    let colorTemplates = ColorTemplate.allTemplates
    let iconDatas = IconData.allIconDatas
    var isSavedButtonEnabled = false
    var selectedColorTemplate: ColorTemplate? {
        didSet { updateButtonState() }
    }
    var selectedIconData: IconData? {
        didSet {  updateButtonState() }
    }
}

// MARK: API
extension ChangeAvatarViewModel {
    func updateAvatar() async {
        guard let selectedColorTemplate, let selectedIconData else {
            return
        }
        
        guard let currentUser = userSession.currentUser else {
            handleError(AppError.internalError(.userNotFound))
            return
        }
        
        isLoading = true
        do {
            let avatarDict = currentUser.avatar
                .dictionaryBuilder()
                .colorTemplate(selectedColorTemplate)
                .iconData(selectedIconData)
                .dictionary
            
            let dict = currentUser.dictionaryBuilder()
                .avatar(avatarDict)
                .dictionary.asSendable
            
            try await apiClient.updateUser(uid: currentUser.id, fields: dict)
            
            // update saved user session
            userSession.currentUser?.avatar.colorTemplate = selectedColorTemplate
            userSession.currentUser?.avatar.iconData = selectedIconData
            
            isLoading = false
            
            // show alert
            changeAvatarSuccess()
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

// MARK: Private Method
extension ChangeAvatarViewModel {
    private func updateButtonState() {
        isSavedButtonEnabled = hasChanges()
    }
    
    private func hasChanges() -> Bool {
        selectedColorTemplate != originalColorTemplate || selectedIconData != originalIconData
    }
}

// MARK: Alert
extension ChangeAvatarViewModel {
    private func changeAvatarSuccess() {
        coordinator?.showSuccessAlert(message: l10.changeAvatarAlertSuccess)
    }
    
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
