import SwiftUI

struct MainTabView: View {
    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var viewModel: MainTabViewModel
    
    var body: some View {
        Text("Main Tab View")
    }
}

#Preview {
    MainTabView(viewModel: MainTabViewModel())
}
