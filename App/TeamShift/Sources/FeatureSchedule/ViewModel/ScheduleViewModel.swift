import Foundation
import Observation

@Observable @MainActor
final class ScheduleViewModel {
    init(coordinator: ScheduleViewModel) {
        self.coordinator = coordinator
    }
    
    @ObservationIgnored
    weak var coordinator: ScheduleViewModel?
}
