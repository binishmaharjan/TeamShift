import SwiftUI

struct ChangePasswordView: View {
    // MARK: Init
    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ChangePasswordViewModel
    
    var body: some View {
        VStack {
            Text("Change Password View")
                .font(.customHeadline)
        }
        .background(Color.background)
    }
}

#Preview {
    ChangePasswordView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
