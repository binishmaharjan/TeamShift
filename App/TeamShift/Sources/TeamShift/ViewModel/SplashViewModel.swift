import ClientAuthentication
import Foundation
import Observation

// TODO: Fetch Maintenance Info
// TODO: Add: AppCheck
// TODO: layout for forgot password email
@Observable @MainActor
final class SplashViewModel {
    init(coordinator: SplashCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    weak var coordinator: SplashCoordinator?
    
    @ObservationIgnored
    private var userSession = UserSession.shared
    
    // MARK: Methods
    func showNextView() async {
        if userSession.isLoggedIn {
            let clock = ContinuousClock()
            try? await clock.sleep(for: .seconds(1))
            coordinator?.finish(with: .showMainTab)
        } else {
            let clock = ContinuousClock()
            try? await clock.sleep(for: .seconds(1))
            coordinator?.finish(with: .showAuthentication)
        }
    }
}
