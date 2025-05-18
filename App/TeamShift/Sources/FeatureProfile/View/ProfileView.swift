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
                profileImage
                    .padding(.vertical, 20)

                ForEach(viewModel.sections, id: \.self) { section in
                    sectionView(for: section)
                        .padding(.bottom, 20)
                }
                
                signOutButton
                .padding(.bottom, 20)
            }
            .padding(.bottom, 10)
            .background(Color.listBackground)
        }
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
        .background(Color.listBackground.ignoresSafeArea())
    }
}

extension ProfileView {
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
    }
   
    private var signOutButton: some View {
        PrimaryButton(image: .icnLogout, title: "Sign Out") {
            Task {
                await viewModel.signOutButtonTapped()
            }
        }
        .padding(.horizontal)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.customFootnote.bold())
            .foregroundStyle(Color.subText)
            .textCase(nil)
            .padding(.leading, 20)
            .padding(.bottom, 5)
    }
    
    private func sectionView(for section: ProfileSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(section.title)
            
            VStack(spacing: 0) {
                ForEach(section.rows, id: \.self) { row in
                    ListLinkRow(profileRow: row)
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
