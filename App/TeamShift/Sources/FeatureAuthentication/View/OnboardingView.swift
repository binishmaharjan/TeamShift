import SharedUIs
import SwiftUI

struct OnboardingView: View {
    init(coordinator: AuthenticationCoordinator, viewModel: OnboardingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    private weak var coordinator: AuthenticationCoordinator?
    @State private var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack {
            Text("Onboarding View")
        }
        .frame(maxHeight: .infinity)
        .task {
            await viewModel.performSomeAction()
        }
    }
}

