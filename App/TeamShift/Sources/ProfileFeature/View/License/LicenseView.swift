import SwiftUI

struct LicenseView: View {
    // MARK: Init
    init(viewModel: LicenseViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: LicenseViewModel
    
    var body: some View {
        ScrollView {
            licenseList
            .padding(.vertical, 16)
        }
    }
}

// MARK: Views
extension LicenseView {
    private var licenseList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.licenses) { license in
                licenseRow(for: license)
                
                if license != viewModel.licenses.last {
                    Divider().padding(.leading, 16)
                }
            }
        }
        .listSectionBlockStyle()
    }
    
    private func licenseRow(for license: LicensePlugin.License) -> some View {
        Button {
            viewModel.licenseRowTapped(for: license)
        } label: {
            HStack {
                Image.icnDescription
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.appPrimary)

                Text(license.name)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .renderingMode(.template)
                    .foregroundStyle(Color.appPrimary)
            }
            .contentShape(Rectangle())
            .font(.customSubHeadline)
            .foregroundStyle(Color.textPrimary)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    LicenseView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
