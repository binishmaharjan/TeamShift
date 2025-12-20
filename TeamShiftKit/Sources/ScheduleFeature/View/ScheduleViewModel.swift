import Foundation
import Observation

@Observable @MainActor
final class ScheduleViewModel {
    init(coordinator: ScheduleCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservationIgnored
    weak var coordinator: ScheduleCoordinator?
}
