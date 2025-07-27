import ApiClient
import UserSessionClient
import Dependencies
import Foundation
import Observation

/* TODO:
 Fetch Maintenance Info
 Add: AppCheck
 Refactor Localization: LocalizedStringResource
 */
@Observable @MainActor
final class SplashViewModel {
    init(coordinator: SplashCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    weak var coordinator: SplashCoordinator?
    
    @ObservationIgnored
    @Dependency(\.userSession) var userSession
    @ObservationIgnored
    @Dependency(\.apiClient) var apiClient
    
    // MARK: Methods
    
    func startInitialFlow() async {
        do {
            _ = try await apiClient.getAppConfig()
            if userSession.isLoggedIn, let uid = userSession.uid {
                try await apiClient.getCurrentUser(uid: uid)
                
                coordinator?.finish(with: .showMainTab)
            } else {
                coordinator?.finish(with: .showAuthentication)
            }
        } catch {
            coordinator?.finish(with: .showAuthentication)
        }
    }
}
