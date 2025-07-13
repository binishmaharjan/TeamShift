import SwiftUI

struct LicenseView: View {
    // MARK: Init
    init(viewModel: LicenseViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: LicenseViewModel
    
    var body: some View {
        VStack {
            Text("License View")
                .font(.customHeadline)
        }
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    LicenseView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
