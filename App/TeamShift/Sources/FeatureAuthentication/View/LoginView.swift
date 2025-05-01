import SwiftUI

struct LoginView: View {
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var viewModel: LoginViewModel
    
    var body: some View {
        Text("LoginView")
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
