import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class AddWorkplaceViewModel {
    init(coordinator: WorkplaceCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    @ObservationIgnored
    private weak var coordinator: WorkplaceCoordinator?
    
    var workplaceName: String = ""
    var branchName: String = ""
    var locationName: String = ""
    var locationCoords: Coordinate?
    var phoneNumber: String = ""
    var description: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
}
