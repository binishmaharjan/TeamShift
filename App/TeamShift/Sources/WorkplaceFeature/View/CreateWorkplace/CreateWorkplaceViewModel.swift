import ApiClient
import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs
import UserSessionClient

@Observable @MainActor
final class CreateWorkplaceViewModel {
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
    var isLoading = false
    
    func createWorkplaceButtonTapped() async {
        let newWorkplace = Workplace(
            name: workplaceName,
            ownerId: "",
            branchName: branchName,
            locationName: locationName,
            locationCoords: locationCoords,
            phoneNumber: phoneNumber,
            description: description
        )
        isLoading = true
        
        do {
            isLoading = false
            try await apiClient.createWorkplace(workplace: newWorkplace)
        } catch {
            isLoading = false
        }
    }
    
    func onLocationPickerTapped() {
        coordinator?.showLocationPicker { coordinates in
            print("Coordinates: \(coordinates)")
        }
    }
}

extension CreateWorkplaceViewModel {
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
