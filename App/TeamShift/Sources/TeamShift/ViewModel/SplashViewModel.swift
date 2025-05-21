import ClientAuthentication
import ClientUserStore
import Dependencies
import Foundation
import Observation

/* TODO:
 Fetch Maintenance Info
 Add: AppCheck
 */
@Observable @MainActor
final class SplashViewModel {
    init(coordinator: SplashCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    weak var coordinator: SplashCoordinator?
    
    @ObservationIgnored
    private var userSession = UserSession.shared
    @ObservationIgnored
    @Dependency(\.userStoreClient) var userStoreClient
    
    // MARK: Methods
    func showNextView() async {
        if userSession.isLoggedIn, let uid = userSession.uid {
            do {
                let user = try await userStoreClient.getUser(uid: uid)
                
                // save user to user session
                UserSession.shared.appUser = user
                
                coordinator?.finish(with: .showMainTab)
            } catch {
                coordinator?.finish(with: .showAuthentication)
            }
        } else {
            let clock = ContinuousClock()
            try? await clock.sleep(for: .seconds(1))
            coordinator?.finish(with: .showAuthentication)
        }
    }
}
