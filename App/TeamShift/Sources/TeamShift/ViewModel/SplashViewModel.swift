import ClientAuthentication
import Foundation
import Observation

@Observable @MainActor
final class SplashViewModel {
    // MARK: Properties
    var didRequestFinish: ((SplashResult) -> Void)?
    
    @ObservationIgnored
    private var userSession = UserSession.shared
    
    // TODO: Fetch Maintenance Info
    // TODO: Add: AppCheck
    // MARK: Methods
    func showNextView() async {
        if userSession.isLoggedIn {
            didRequestFinish?(.showMainTab)
        } else {
            let clock = ContinuousClock()
            try? await clock.sleep(for: .seconds(1))
            didRequestFinish?(.showAuthentication)
        }
    }
}
