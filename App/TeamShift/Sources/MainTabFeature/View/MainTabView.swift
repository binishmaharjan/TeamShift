import SwiftUI

struct MainTabView: View {
    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var viewModel: MainTabViewModel
    
    var body: some View {
        Button {
            viewModel.doneButtonTapped()
        } label: {
            Text("Done")
        }
    }
}

#Preview {
    MainTabView(viewModel: MainTabViewModel())
}
