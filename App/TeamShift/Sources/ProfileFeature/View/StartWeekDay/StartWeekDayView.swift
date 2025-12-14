import SwiftUI

struct StartWeekDayView: View {
    // MARK: Init
    init(viewModel: StartWeekDayViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: StartWeekDayViewModel
    
    var body: some View {
        VStack {
            Text("Start WeekDay View")
                .font(.customHeadline)
        }
    }
}

#Preview {
    StartWeekDayView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
