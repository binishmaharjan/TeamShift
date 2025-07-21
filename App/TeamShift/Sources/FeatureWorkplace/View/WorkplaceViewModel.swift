import Foundation
import Observation

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
    
    func addWorkplaceButtonTapped() {
        coordinator?.workplaceRequestNavigation(for: .showAddWorkplace)
    }
}
