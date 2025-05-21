import SwiftUI

struct SplashView: View {
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
    }
    
    private weak var coordinator: SplashCoordinator?
    @State private var viewModel: SplashViewModel
    
    var body: some View {
        VStack {
            Image.teamShift
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxHeight: .infinity)
        .task {
            await viewModel.startInitialFlow()
        }
    }
}
