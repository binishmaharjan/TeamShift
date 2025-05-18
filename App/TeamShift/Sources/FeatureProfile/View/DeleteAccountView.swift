import SwiftUI

struct DeleteAccountView: View {
    // MARK: Init
    init(viewModel: DeleteAccountViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: DeleteAccountViewModel
    
    var body: some View {
        VStack {
            Text("Delete Account View")
                .font(.customHeadline)
        }
        .background(Color.background)
    }
}

#Preview {
    DeleteAccountView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
