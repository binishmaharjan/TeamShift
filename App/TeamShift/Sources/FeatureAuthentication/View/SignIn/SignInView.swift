import SharedUIs
import SwiftUI

struct SignInView: View {
    enum FocusableField: Hashable {
        case email
        case password
    }
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: SignInViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack(spacing: 12) {
            emailTextField
                .padding(.top, 24)
            
            passwordTextField
            
            signInButton
            
           forgotPasswordButton

            separator
                .padding(.bottom, 12)
            
            signInGoogleButton
            
            signInAppleButton
        }
        .padding(.horizontal, 24)
        .vSpacing(.top)
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
    }
}

extension SignInView {
    @ViewBuilder
    private var emailTextField: some View {
        PrimaryTextField(
            l10.commonTextFieldEmail,
            icon: .icnMail,
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
            icon: .icnLock,
            text: $viewModel.password,
            fieldIdentifier: .password,
            focusedField: $focusedField,
            isSecure: true
        )
    }
    
    @ViewBuilder
    private var signInButton: some View {
        PrimaryButton(title: l10.signInButtonSignIn) {
            Task {
                await viewModel.signInButtonTapped()
            }
        }
        .disabled(!viewModel.isSignInButtonEnabled)
    }
    
    @ViewBuilder
    private var forgotPasswordButton: some View {
        Button {
            viewModel.forgotPasswordButtonTapped()
        } label: {
            Text(l10.signInButtonForgotPassword)
                .font(.customFootnote.bold())
                .foregroundStyle(Color.appPrimary)
                .hSpacing(.trailing)
        }
        .padding(.bottom, 12)
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
            title: l10.signInButtonWithGoogle,
            isTemplate: false
        ) {
            Task {
                await viewModel.signInWithGoogleButtonTapped()
            }
        }
    }
    
    @ViewBuilder
    private var signInAppleButton: some View {
        SecondaryButton(
            image: .icnApple,
            title: l10.signInButtonWithApple,
            isTemplate: false
        ) {
            print(l10.signInButtonWithApple)
        }
    }
}

#Preview {
    SignInView(viewModel: SignInViewModel(coordinator: .init()))
}
