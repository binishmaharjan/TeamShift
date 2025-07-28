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
            PrimaryTextField(
                l10.createWorkplaceFormName,
                kind: .icon(image: .icnStore),
                text: $viewModel.workplaceName,
                fieldIdentifier: .name,
                focusedField: $focusedField
            )
            
            PrimaryTextField(
                l10.createWorkplaceFormBranchName,
                kind: .icon(image: .icnBranch),
                text: $viewModel.branchName,
                fieldIdentifier: .branchName,
                focusedField: $focusedField
            )
            
            LocationTextField(
                l10.createWorkplaceFormAddress,
                image: .icnDomain,
                text: $viewModel.locationName,
                fieldIdentifier: .address,
                focusedField: $focusedField
            )
            
            PrimaryTextField(
                l10.createWorkplaceFormPhoneNumber,
                kind: .icon(image: .icnCall),
                text: $viewModel.phoneNumber,
                fieldIdentifier: .phoneNumber,
                focusedField: $focusedField,
                keyboardType: .phonePad
            )
            
            PrimaryTextField(
                l10.createWorkplaceFormDescription,
                kind: .editor(height: 150),
                text: $viewModel.description,
                fieldIdentifier: .description,
                focusedField: $focusedField
            )
            
            PrimaryButton(title:  l10.createWorkplaceButtonCreate) {
                print(l10.createWorkplaceButtonCreate)
            }
        }
        .background(Color.backgroundPrimary)
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .vSpacing(.top)
        .loadingView(viewModel.isLoading)
    }
}

#Preview {
    CreateWorkplaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
