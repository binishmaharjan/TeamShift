import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class ChangeAvatarViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    var selectedColorTemplate: ColorTemplate?
    var selectedIconData: IconData?
    
    let colorTemplates = ColorTemplate.allTemplates
    let iconDatas = IconData.allIconDatas
}
