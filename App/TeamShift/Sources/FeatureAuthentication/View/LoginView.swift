import SwiftUI

struct LoginView: View {
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: LoginViewModel
    
    var body: some View {
        Text("LoginView")
        
        Button {
            viewModel.loginButtonTapped()
        } label: {
            Text("Done")
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
