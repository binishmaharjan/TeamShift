import SharedUIs
import SwiftUI

struct CreateWorkplaceView: View {
    enum FocusableField: Hashable {
        case name
        case branchName
        case address
        case phoneNumber
        case description
    }
    
    // MARK: Init
    init(viewModel: CreateWorkplaceViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: CreateWorkplaceViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack {
            workNameTextField
            
            branchNameTextField
            
            addressTextField
            
            phoneNumberTextField
            
            descriptionTextField
            
            createButton
        }
        .loadingView(viewModel.isLoading)
        .hideKeyboardOnTap()
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .vSpacing(.top)
    }
}

// MARK: Views
extension CreateWorkplaceView {
    @ViewBuilder
    private var workNameTextField: some View {
        PrimaryTextField(
            l10.createWorkplaceFormName,
            kind: .icon(image: .icnStore),
            text: $viewModel.workplaceName,
            fieldIdentifier: .name,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var branchNameTextField: some View {
        PrimaryTextField(
            l10.createWorkplaceFormBranchName,
            kind: .icon(image: .icnBranch),
            text: $viewModel.branchName,
            fieldIdentifier: .branchName,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var addressTextField: some View {
        LocationTextField(
            l10.createWorkplaceFormAddress,
            image: .icnDomain,
            text: $viewModel.locationName,
            fieldIdentifier: .address,
            focusedField: $focusedField
        ) {
            viewModel.onLocationPickerTapped()
        }
    }
    
    @ViewBuilder
    private var phoneNumberTextField: some View {
        PrimaryTextField(
            l10.createWorkplaceFormPhoneNumber,
            kind: .icon(image: .icnCall),
            text: $viewModel.phoneNumber,
            fieldIdentifier: .phoneNumber,
            focusedField: $focusedField,
            keyboardType: .phonePad
        )
    }
    
    @ViewBuilder
    private var descriptionTextField: some View {
        PrimaryTextField(
            l10.createWorkplaceFormDescription,
            kind: .editor(height: 150),
            text: $viewModel.description,
            fieldIdentifier: .description,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var createButton: some View {
        PrimaryButton(title:  l10.createWorkplaceButtonCreate) {
            Task {
                await viewModel.createWorkplaceButtonTapped()
            }
        }
        .disabled(!viewModel.isCreateButtonEnabled)
    }
}

#Preview {
    CreateWorkplaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
