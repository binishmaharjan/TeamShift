import ApiClient
import Dependencies
import Foundation
import LocationKit
import Observation
import SharedModels

@Observable @MainActor
final class WorkplaceViewModel {
    // MARK: Enum
    enum Route {
        case showAddWorkplace
    }
    
    // MARK: Init
    init(coordinator: WorkplaceCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    @ObservationIgnored
    weak var coordinator: WorkplaceCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) private var apiClient
    @ObservationIgnored
    @Dependency(\.userSession) private var userSession
    
    var isLoading = false
    
    func addWorkplaceButtonTapped() {
        coordinator?.workplaceRequestNavigation(for: .showAddWorkplace)
        Task {
            let workPlaces = try? await apiClient.getWorkplace(user: userSession.currentUser!)
            workPlaces?.forEach { workplace in
                print(workplace)
            }
        }
    }
    
    func onViewAppear() async {
        guard let currentUser = userSession.currentUser else {
            handleError(AppError.internalError(.userNotFound))
            return
        }
        
        isLoading = true
        
        do {
            isLoading = false
            let workPlaces = try await apiClient.getWorkplace(user: currentUser)
            workPlaces.forEach { workplace in
                print(workplace)
            }
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

// MARK: Alert
extension WorkplaceViewModel {
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
