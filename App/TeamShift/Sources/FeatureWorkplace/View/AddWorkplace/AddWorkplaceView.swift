import SharedUIs
import SwiftUI

struct AddWorkplaceView: View {
    enum FocusableField: Hashable {
        case name
        case branchName
        case address
        case phoneNumber
        case description
    }
    
    // MARK: Init
    init(viewModel: AddWorkplaceViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: AddWorkplaceViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack {
            PrimaryTextField(
                "Workplace Name",
                kind: .icon(image: .icnStore),
                text: $viewModel.workplaceName,
                fieldIdentifier: .name,
                focusedField: $focusedField
            )
            
            PrimaryTextField(
                "Branch Name(Optional)",
                kind: .icon(image: .icnBranch),
                text: $viewModel.branchName,
                fieldIdentifier: .branchName,
                focusedField: $focusedField
            )
            
            PrimaryTextField(
                "Address(Optional)",
                kind: .icon(image: .icnDomain),
                text: $viewModel.locationName,
                fieldIdentifier: .address,
                focusedField: $focusedField
            )
            
            PrimaryTextField(
                "Phone Number(Optional)",
                kind: .icon(image: .icnCall),
                text: $viewModel.phoneNumber,
                fieldIdentifier: .phoneNumber,
                focusedField: $focusedField,
                keyboardType: .phonePad
            )
            
            PrimaryTextField(
                "Description(Optional)",
                kind: .editor(height: 150),
                text: $viewModel.description,
                fieldIdentifier: .description,
                focusedField: $focusedField
            )
            
            PrimaryButton(title: "Add Workplace") {
                print("Add Workplace")
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
    AddWorkplaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
