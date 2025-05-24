import SharedUIs
import SwiftUI

struct ChangePasswordView: View {
    enum FocusableField: Hashable {
        case oldPassword
        case newPassword
        case confirmPassword
    }
    
    // MARK: Init
    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ChangePasswordViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack(spacing: 12) {
            oldPasswordTextField
                .padding(.top, 24)
            
            newPasswordTextField
            
            confirmPasswordTextField
            
            changePasswordButton
        }
        .padding(.horizontal, 24)
        .vSpacing(.top)
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
        .background(Color.background)
    }
}
extension ChangePasswordView {    
    @ViewBuilder
    private var oldPasswordTextField: some View {
        PrimaryTextField(
            "Old Password",
            icon: .icnLock,
            text: $viewModel.oldPassword,
            fieldIdentifier: .oldPassword,
            focusedField: $focusedField,
            isSecure: true
        )
    }
    
    @ViewBuilder
    private var newPasswordTextField: some View {
        PrimaryTextField(
            "New Password",
            icon: .icnLock,
            text: $viewModel.newPassword,
            fieldIdentifier: .newPassword,
            focusedField: $focusedField,
            isSecure: true
        )
    }
    @ViewBuilder
    private var confirmPasswordTextField: some View {
        PrimaryTextField(
            "Confirm Password",
            icon: .icnLock,
            text: $viewModel.confirmPassword,
            fieldIdentifier: .confirmPassword,
            focusedField: $focusedField,
            isSecure: true
        )
    }
    
    @ViewBuilder
    private var changePasswordButton: some View {
        PrimaryButton(title: "Change Password") {
            Task {
                await viewModel.changePasswordButtonTapped()
            }
        }
        .disabled(!viewModel.isChangePasswordButtonEnabled)
    }
}

#Preview {
    ChangePasswordView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
