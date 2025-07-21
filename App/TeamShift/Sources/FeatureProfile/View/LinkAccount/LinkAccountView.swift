import SharedUIs
import SwiftUI

struct LinkAccountView: View {
    enum FocusableField: Hashable {
        case email
        case password
    }
    
    // MARK: Init
    init(viewModel: LinkAccountViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: LinkAccountViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack {
            emailTextField
            
            passwordTextField
            
            signInButton

            separator
                .padding(.bottom, 12)
            
            signInGoogleButton
            
            signInAppleButton
        }
        .background(Color.backgroundPrimary)
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .vSpacing(.top)
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
    }
}

extension LinkAccountView {
    @ViewBuilder
    private var emailTextField: some View {
        PrimaryTextField(
            l10.commonTextFieldEmail,
            kind: .icon(image: .icnMail),
            text: $viewModel.email,
            fieldIdentifier: .email,
            focusedField: $focusedField,
            keyboardType: .emailAddress
        )
    }
    
    @ViewBuilder
    private var passwordTextField: some View {
        PrimaryTextField(
            l10.commonTextFieldPassword,
            kind: .secure(image: .icnLock),
            text: $viewModel.password,
            fieldIdentifier: .password,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var signInButton: some View {
        PrimaryButton(title: l10.linkAccountButtonEmail) {
            Task {
                await viewModel.linkButtonTapped()
            }
        }
        .disabled(!viewModel.isSignInButtonEnabled)
    }
    
    @ViewBuilder
    private var separator: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
            
            Text("or")
                .font(.customFootnote)
            
            Rectangle()
                .frame(height: 1)
        }
        .foregroundStyle(Color.textPrimary.opacity(0.5))
    }
    
    @ViewBuilder
    private var signInGoogleButton: some View {
        SecondaryButton(
            image: .icnGoogle,
            title: l10.linkAccountButtonGmail,
            isTemplate: false
        ) {
            Task {
                await viewModel.linkWithGoogleButtonTapped()
            }
        }
    }
    
    @ViewBuilder
    private var signInAppleButton: some View {
        SecondaryButton(
            image: .icnApple,
            title: l10.linkAccountButtonApple,
            isTemplate: false
        ) {
            print(l10.signInButtonWithApple)
        }
    }
}

#Preview {
    LinkAccountView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
