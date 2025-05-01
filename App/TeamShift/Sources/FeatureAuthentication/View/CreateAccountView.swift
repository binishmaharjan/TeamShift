import SwiftUI

struct CreateAccountView: View {
    init(viewModel: CreateAccountViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var viewModel: CreateAccountViewModel
    
    var body: some View {
        Text("Create Account")
    }
}

#Preview {
    CreateAccountView(viewModel: CreateAccountViewModel())
}
