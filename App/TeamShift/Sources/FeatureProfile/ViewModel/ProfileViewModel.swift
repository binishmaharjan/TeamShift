import Foundation
import Observation

@Observable @MainActor
final class ProfileViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservationIgnored
    weak var coordinator: ProfileCoordinator?
}
