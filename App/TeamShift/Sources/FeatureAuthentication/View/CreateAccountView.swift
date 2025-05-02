import SwiftUI

struct CreateAccountView: View {
    init(viewModel: CreateAccountViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: CreateAccountViewModel
    
    var body: some View {
        Text("Create Account")
        
        Button {
            viewModel.createButtonTapped()
        } label: {
            Text("Done")
        }
    }
}

#Preview {
    CreateAccountView(viewModel: CreateAccountViewModel())
}
