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
        VStack(spacing: 12) {
            title
                .padding(.bottom, 48)
            
            emailTextField
            
            passwordTextField
            
            createButton
                .padding(.bottom, 12)
    
            separator
                .padding(.bottom, 12)
            
            SecondaryButton(image: .icnGoogle, title: "Sign up with Google", isTemplate: false) { }
            SecondaryButton(image: .icnApple, title: "Sign up with Apple", isTemplate: false) { }
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
