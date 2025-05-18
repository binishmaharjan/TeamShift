import SwiftUI

struct LinkAccountView: View {
    // MARK: Init
    init(viewModel: LinkAccountViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: LinkAccountViewModel
    
    var body: some View {
        VStack {
            Text("Link Account View")
                .font(.customHeadline)
        }
        .background(Color.background)
    }
}

#Preview {
    LinkAccountView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
