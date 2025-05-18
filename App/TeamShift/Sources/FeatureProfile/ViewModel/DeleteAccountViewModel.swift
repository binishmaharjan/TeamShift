import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class DeleteAccountViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
}
