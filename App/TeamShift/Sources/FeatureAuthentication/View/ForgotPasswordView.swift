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
            title
                .padding(.bottom, 48)
            
            description
                .padding(.bottom, 24)
            
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
    private var title: some View {
        Text(l10.forgotPasswordTitle)
            .foregroundStyle(Color.text)
            .font(.customTitle)
    }
    
    @ViewBuilder
    private var description: some View {
        Text(l10.forgotPasswordDescription)
            .frame(maxWidth: .infinity)
            .font(.customCaption)
            .foregroundStyle(Color.subText)
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
