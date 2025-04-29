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
            Spacer()
            
            Button {
                print("Find a Service")
            } label: {
                Text(Strings.findAService)
            }
            .buttonStyle(.primary)
            
            Button {
                print("Become Freelancer")
            } label: {
                Text(Strings.becomeFreelancer)
            }
            .buttonStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(Color.background)
        .task {
            await viewModel.performSomeAction()
        }
    }
}
