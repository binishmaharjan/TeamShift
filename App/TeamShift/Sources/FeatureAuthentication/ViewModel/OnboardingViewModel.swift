import Foundation
import SwiftUI

@Observable @MainActor
final class OnboardingViewModel {
    func performSomeAction() async {
        print("Will perform action")
    }
}
