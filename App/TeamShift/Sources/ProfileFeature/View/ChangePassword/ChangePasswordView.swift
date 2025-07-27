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
        .background(Color.backgroundPrimary)
    }
}
extension ChangePasswordView {    
    @ViewBuilder
    private var oldPasswordTextField: some View {
        PrimaryTextField(
            l10.changePasswordTextFieldOldPassword,
            kind: .secure(image: .icnLock),
            text: $viewModel.oldPassword,
            fieldIdentifier: .oldPassword,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var newPasswordTextField: some View {
        PrimaryTextField(
            l10.changePasswordTextFieldNewPassword,
            kind: .secure(image: .icnLock),
            text: $viewModel.newPassword,
            fieldIdentifier: .newPassword,
            focusedField: $focusedField
        )
    }
    @ViewBuilder
    private var confirmPasswordTextField: some View {
        PrimaryTextField(
            l10.changePasswordTextFieldConfrimPassword,
            kind: .secure(image: .icnLock),
            text: $viewModel.confirmPassword,
            fieldIdentifier: .confirmPassword,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var changePasswordButton: some View {
        PrimaryButton(title: l10.changePasswordButtonChange) {
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
