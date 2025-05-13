import Foundation
import Observation

@Observable @MainActor
final class WorkplaceViewModel {
    init(coordinator: WorkplaceCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservationIgnored
    weak var coordinator: WorkplaceCoordinator?
}
