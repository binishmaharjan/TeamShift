import SharedUIs
import SwiftUI

struct ForgotPasswordView: View {
    enum FocusableField: Hashable {
        case email
    }
    
    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ForgotPasswordViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack(spacing: 12) {
            description
                .padding(.vertical, 24)
            
            emailTextField
            
            sendEmailButton
        }
        .padding(.horizontal, 24)
        .vSpacing(.top)
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
    }
}

extension ForgotPasswordView {
    @ViewBuilder
    private var description: some View {
        Text(l10.forgotPasswordDescription)
            .frame(maxWidth: .infinity)
            .font(.customCaption)
            .foregroundStyle(Color.textSecondary)
            .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    private var emailTextField: some View {
        PrimaryTextField(
            l10.commonTextFieldEmail,
            icon: .icnMail,
            text: $viewModel.email,
            fieldIdentifier: .email,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var sendEmailButton: some View {
        PrimaryButton(title: l10.forgotPasswordButtonSendEmail) {
            Task {
                await viewModel.sendEmailButtonTapped()
            }
        }
        .disabled(!viewModel.isEmailValid)
    }
}
