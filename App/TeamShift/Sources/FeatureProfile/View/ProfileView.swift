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
                
                accountSection
                    .padding(.bottom, 20)
                
                preferenceSection
                .padding(.bottom, 20)
                
                otherSection
                .padding(.bottom, 20)
                
                signOutButton
                .padding(.bottom, 20)
            }
            .padding(.bottom, 10)
            .background(Color.listBackground)
        }
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
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle("Account")
            
            VStack(spacing: 0) {
                NavigationLinkRow(title: "Change Password", image: .icnWaterLock)
                
                Divider().padding(.leading, 20)
                
                NavigationLinkRow(title: "Link Account", image: .icnLink)
                
                Divider().padding(.leading, 20)
                
                NavigationLinkRow(title: "Delete Password", image: .icnDeleteUser)
            }
            .listSectionBlockStyle()
        }
    }
    
    private var preferenceSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle("Preference")
            
            VStack(spacing: 0) {
                NavigationLinkRow(title: "Start Week Day", image: .icnEvent)
                
                Divider().padding(.leading, 20)
                
                NavigationLinkRow(title: "Show Public Holiday", image: .icnGlobe)
            }
            .listSectionBlockStyle()
        }
    }
    
    private var otherSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle("Others")
            
            VStack(spacing: 0) {
                NavigationLinkRow(title: "License", image: .icnDescription)
            }
            .listSectionBlockStyle()
        }
    }
    
    private var signOutButton: some View {
        PrimaryButton(image: .icnLogout, title: "Sign Out") {
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
}

#Preview {
    ProfileView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
