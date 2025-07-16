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
        self.originalColorTemplate = userSession.currentUser?.colorTemplate
        self.originalIconData = userSession.currentUser?.iconData
        
        // Initialize selected values
        self.selectedColorTemplate = userSession.currentUser?.colorTemplate
        self.selectedIconData = userSession.currentUser?.iconData
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
    
    var alertConfig: AlertDialog.Config?
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
            showErrorAlert(AppError.internalError(.userNotFound))
            return
        }
        
        isLoading = true
        do {
            let dict = currentUser.dictionaryBuilder()
                .colorTemplate(selectedColorTemplate)
                .iconData(selectedIconData)
                .dictionary.asSendable
            try await apiClient.updateUser(uid: currentUser.id, fields: dict)
            
            // update saved user session
            userSession.currentUser?.colorTemplate = selectedColorTemplate
            userSession.currentUser?.iconData = selectedIconData
            
            isLoading = false
            
            // show alert
            changeAvatarSuccess()
        } catch {
            isLoading = false
            showErrorAlert(error)
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
        alertConfig = .success(message: l10.changeAvatarAlertSuccess) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
