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
    
    func startInitialFlow() async {
        do {
            _ = try await userStoreClient.getAppConfig()
            if userSession.isLoggedIn, let uid = userSession.uid {
                let user = try await userStoreClient.getUser(uid: uid)
                
                // save user to user session
                UserSession.shared.appUser = user
                
                coordinator?.finish(with: .showMainTab)
            } else {
                coordinator?.finish(with: .showAuthentication)
            }
        } catch {
            coordinator?.finish(with: .showAuthentication)
        }
    }
}
