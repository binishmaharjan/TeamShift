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
            title
                .padding(.bottom, 48)
            
            emailTextField
            
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
    }
}

extension SignInView {
    @ViewBuilder
    private var title: some View {
        Text(l10.signIn)
            .foregroundStyle(Color.text)
            .font(.customTitle)
    }
    
    @ViewBuilder
    private var emailTextField: some View {
        PrimaryTextField(
            l10.email,
            icon: .icnMail,
            text: $viewModel.email,
            fieldIdentifier: .email,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var passwordTextField: some View {
        PrimaryTextField(
            l10.password,
            icon: .icnLock,
            text: $viewModel.password,
            fieldIdentifier: .password,
            focusedField: $focusedField,
            isSecure: true
        )
    }
    
    @ViewBuilder
    private var signInButton: some View {
        PrimaryButton(title: l10.signIn) { }
    }
    
    @ViewBuilder
    private var forgotPasswordButton: some View {
        Button {
            print(l10.forgotPassword)
        } label: {
            Text(l10.forgotPassword)
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
        .foregroundStyle(Color.text.opacity(0.5))
    }
    
    @ViewBuilder
    private var signInGoogleButton: some View {
        SecondaryButton(
            image: .icnGoogle,
            title: l10.signInWithGoogle,
            isTemplate: false
        ) {
            print(l10.signUpWithGoogle)
        }
    }
    
    @ViewBuilder
    private var signInAppleButton: some View {
        SecondaryButton(
            image: .icnApple,
            title: l10.signInWithApple,
            isTemplate: false
        ) {
            print(l10.signUpWithApple)
        }
    }
}

#Preview {
    SignInView(viewModel: SignInViewModel())
}
