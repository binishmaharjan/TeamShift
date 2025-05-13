import SharedUIs
import SwiftUI

struct ProfilView: View {
    // MARK: Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ProfileViewModel
    
    var body: some View {
        Text("Profile View")
            .font(.customHeadline)
    }
}

#Preview {
    ProfilView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
