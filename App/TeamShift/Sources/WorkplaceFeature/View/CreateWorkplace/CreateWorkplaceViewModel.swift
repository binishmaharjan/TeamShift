import ApiClient
import Dependencies
import Foundation
import LocationKit
import Observation
import SharedModels
import SharedUIs
import UserSessionClient

@Observable @MainActor
final class CreateWorkplaceViewModel {
    enum Route {
        case showWorkplaceDetail(Workplace)
    }
    
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
    @ObservationIgnored
    @Dependency(\.locationGeoCoder) private var locationGeoCoder
    
    var workplaceName: String = ""
    var branchName: String = ""
    var locationName: String = ""
    var locationCoords: Coordinate?
    var phoneNumber: String = ""
    var description: String = ""
    var isLoading = false
    
    var isCreateButtonEnabled: Bool { !workplaceName.isEmpty }
    
    func createWorkplaceButtonTapped() async {
        guard let ownerId = userSession.currentUser?.id else {
            handleError(AppError.internalError(.userNotFound))
            return
        }
        
        let newWorkplace = Workplace(
            name: workplaceName,
            ownerId: ownerId,
            branchName: branchName,
            locationName: locationName,
            locationCoords: locationCoords,
            phoneNumber: phoneNumber,
            description: description
        )
        isLoading = true
        
        do {
            try await apiClient.createWorkplace(workplace: newWorkplace)
            isLoading = false
            createSuccessAlert(for: newWorkplace)
        } catch {
            isLoading = false
            handleError(error)
        }
    }
    
    func onLocationPickerTapped() {
        coordinator?.presentLocationPicker { coordinates in
            guard let coordinates else { return }
            Task { @MainActor in
                let locationName = await self.locationGeoCoder.reverseShort(from: coordinates)
                self.locationCoords = coordinates
                self.locationName = locationName
                print("Coordinates: \(coordinates)")
                print("Location: \(locationName)")
            }
        }
    }
}

extension CreateWorkplaceViewModel {
    private func createSuccessAlert(for workplace: Workplace) {
        coordinator?.createWorkplaceRequestNavigation(for: .showWorkplaceDetail(workplace))
    }
    
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
