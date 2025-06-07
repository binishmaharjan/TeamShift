import SwiftUI

struct ChangePictureView: View {
    // MARK: Init
    init(viewModel: ChangePictureViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ChangePictureViewModel
    
    var body: some View {
        VStack {
            Text("Change Picture View")
                .font(.customHeadline)
        }
        .background(Color.background)
    }
}

#Preview {
    ChangePictureView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
