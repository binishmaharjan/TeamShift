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
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
        .background(Color.background)
    }
}

extension DeleteAccountView {
    @ViewBuilder
    private var title: some View {
        Text("Delete Account")
            .foregroundStyle(Color.text)
            .font(.customHeadline)
    }
    
    @ViewBuilder
    private var description: some View {
        Text(
            """
            We're sorry to see you go. Before you proceed, please understand that deleting your account is a permanent action that cannot be undone.
            
            When you delete your account, all of your data will be permanently removed from our servers. You will no longer be able to access shared schedules, and any pending notifications will be cancelled immediately. This action cannot be reversed once completed. We do not keep backups of deleted accounts for privacy reasons, which means your data cannot be recovered under any circumstances.
            
            If you're certain you want to proceed, your account and all associated data will be permanently deleted. Please take a moment to consider this decision carefully, as it cannot be undone.
            """
        )
        .foregroundStyle(Color.text)
        .font(.customCaption)
        .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    private var separator: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color.text.opacity(0.5))
    }
    
    @ViewBuilder
    private var confirmText: some View {
        Text("I confirm I want to permanently delete my account and all data")
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.text)
            .font(.customCaption)
            .multilineTextAlignment(.leading)
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
    private var deleteButton: some View {
        PrimaryButton(title: "Delete Account") {
            Task {
                print("Delete")
            }
        }
        .disabled(!viewModel.isDeleteButtonEnabled)
    }
}

#Preview {
    DeleteAccountView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
