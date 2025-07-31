import SharedUIs
import SwiftUI

struct DeleteAccountView: View {
    enum FocusableField: Hashable {
        case password
    }
    
    // MARK: Init
    init(viewModel: DeleteAccountViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: DeleteAccountViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            description
                .padding(.top, 24)
            
            separator
            
            confirmText
            
            if viewModel.signInMethod == .email {
                passwordTextField
            }
            
            deleteButton
        }
        .padding(.horizontal, 24)
        .vSpacing(.top)
        .loadingView(viewModel.isLoading)
        .background(Color.backgroundPrimary)
    }
}

extension DeleteAccountView {
    @ViewBuilder
    private var description: some View {
        Text(l10.deleteAccountDescription)
        .foregroundStyle(Color.textPrimary)
        .font(.customCaption)
        .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    private var separator: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color.textPrimary.opacity(0.5))
    }
    
    @ViewBuilder
    private var confirmText: some View {
        Text(l10.deleteAccountConfirmText)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.textPrimary)
            .font(.customCaption)
            .multilineTextAlignment(.leading)
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
    private var deleteButton: some View {
        PrimaryButton(title: "Delete Account") {
            Task {
                await viewModel.deleteButtonTapped()
            }
        }
        .disabled(!viewModel.isDeleteButtonEnabled)
    }
}

#Preview {
    DeleteAccountView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
