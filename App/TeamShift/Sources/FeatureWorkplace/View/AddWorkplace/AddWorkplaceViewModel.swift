import ClientApi
import ClientUserSession
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
    @ObservationIgnored
    @Dependency(\.userSession) private var userSession
    @ObservationIgnored
    @Dependency(\.apiClient) private var apiClient
    
    var workplaceName: String = ""
    var branchName: String = ""
    var locationName: String = ""
    var locationCoords: Coordinate?
    var phoneNumber: String = ""
    var description: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
}
