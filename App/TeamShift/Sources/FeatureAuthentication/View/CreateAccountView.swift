import SharedUIs
import SwiftUI

struct CreateAccountView: View {
    enum FocusableField: Hashable {
        case email
        case password
    }
    
    init(viewModel: CreateAccountViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: CreateAccountViewModel
    @State private var isPasswordSecure: Bool = true
    @FocusState private var focusedField: FocusableField?
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            title
                .padding(.bottom, 24)
            
            emailTextField
            
            passwordTextField
                .padding(.bottom, 12)
            
            createButton
                .padding(.bottom, 24)
    
            separator
                .padding(.bottom, 24)
            
            SecondaryButton(title: "Sign up with Google") { }
            SecondaryButton(title: "Sign up with Facebook") { }
            SecondaryButton(title: "Sign up with Apple") { }
        }
        .padding(.horizontal, 24)
        .vSpacing(.top)
    }
}

extension CreateAccountView {
    @ViewBuilder
    private var title: some View {
        Text("Create Account")
            .foregroundStyle(Color.text)
            .font(.customTitle)
    }
    
    @ViewBuilder
    private var emailTextField: some View {
        PrimaryTextField(
            "Email",
            icon: .icnMail,
            text: $email,
            fieldIdentifier: .email,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var passwordTextField: some View {
        PrimaryTextField(
            "Password",
            icon: .icnLock,
            text: $password,
            fieldIdentifier: .password,
            focusedField: $focusedField,
            isSecure: true
        )
    }
    
    @ViewBuilder
    private var createButton: some View {
        PrimaryButton(title: "Create") { }
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
}

#Preview {
    CreateAccountView(viewModel: CreateAccountViewModel())
}
