import SharedUIs
import SwiftUI

struct WorkPlaceView: View {
    // MARK: Init
    init(viewModel: WorkplaceViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: WorkplaceViewModel
    
    var body: some View {
        VStack {
            Text("WorkPlace View")
                .font(.customHeadline)
        }
        .background(Color.background)
    }
}

#Preview {
    WorkPlaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
