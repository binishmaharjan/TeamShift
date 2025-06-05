import SharedUIs
import SwiftUI

struct ProfileView: View {
    // MARK: Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                userID
                
                profileImage
                    .padding(.vertical, 10)
                
                userName
                .padding(.bottom, 10)

                ForEach(viewModel.sections, id: \.self) { section in
                    sectionView(for: section)
                        .padding(.bottom, 20)
                }
                
                signOutButton
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
            .padding(.bottom, 10)
            .background(Color.listBackground)
        }
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
        .displayToast(handledBy: viewModel.toastHandler)
        .background(Color.listBackground.ignoresSafeArea())
    }
}

extension ProfileView {
    @ViewBuilder
    private var userID: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text(l10.profileUserId)
                
                Text(viewModel.displayUid)
            }
            .font(.customCaption2)
            .foregroundStyle(Color.subText)
            .bold()
            
            Button {
                viewModel.copyUserIDButtonTapped()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.appPrimary)
                        .frame(width: 28, height: 28)
                    
                    Image.icnCopy
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .hSpacing(.trailing)
    }
    
    @ViewBuilder
    private var profileImage: some View {
        Image.imgUser1
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .mask(
                Circle()
            )
            .overlay {
                Circle().fill(.clear).stroke(Color.appPrimary, lineWidth: 2)
            }
            .overlay {
                Button {
                    print("Edit Image")
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.appPrimary)
                            .frame(width: 28, height: 28)
                        
                        Image.icnEdit
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                }
                .offset(x: 36, y: 36)
                .buttonStyle(.plain)
            }
    }
    
    @ViewBuilder
    private var userName: some View {
        HStack {
            Text("viewModel.username")
                .font(.customHeadline)

            Image.icnEdit
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
        }
        .foregroundStyle(Color.text)
        .onTapGesture {
            viewModel.editNameButtonTapped()
        }
    }
   
    @ViewBuilder
    private var signOutButton: some View {
        PrimaryButton(image: .icnLogout, title: l10.profileButtonSignOut) {
            Task {
                await viewModel.signOutButtonTapped()
            }
        }
    }
    
    @ViewBuilder
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.customFootnote.bold())
            .foregroundStyle(Color.subText)
            .textCase(nil)
            .padding(.leading, 20)
    }
    
    @ViewBuilder
    private func sectionView(for section: ProfileSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(section.title)
                .padding(.bottom, 5)
            
            VStack(spacing: 0) {
                ForEach(section.rows, id: \.self) { row in
                    ListLinkRow(profileRow: row) { selectedRow in
                        viewModel.listRowTapped(selectedRow)
                    }
                    if row != section.rows.last {
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .listSectionBlockStyle()
        }
    }
}

#Preview {
    ProfileView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
