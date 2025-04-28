import Foundation
import SwiftUI

@Observable @MainActor
final class SplashViewModel {
    func performSomeAction() async {
        print("Will perform action")
    }
}
