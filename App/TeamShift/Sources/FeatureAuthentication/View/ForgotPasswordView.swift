import SharedUIs
import SwiftUI

struct ForgotPasswordView: View {
    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ForgotPasswordViewModel
    
    var body: some View {
        Text("Forgot Password")
    }
}
