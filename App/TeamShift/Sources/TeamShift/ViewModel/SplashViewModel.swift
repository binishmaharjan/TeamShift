import Foundation
import SwiftUI

@Observable @MainActor
final class SplashViewModel {
    // MARK: Properties
    var didRequestFinish: ((SplashResult) -> Void)?
    
    // MARK: Methods
    func performSomeAction() async {
        let clock = ContinuousClock()
        try? await clock.sleep(for: .seconds(3))
        didRequestFinish?(.showAuthentication)
    }
}
