import SharedUIs
import SwiftUI

struct ScheduleView: View {
    // MARK: Init
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ScheduleViewModel
    
    var body: some View {
        Text("")
    }
}

#Preview {
    ScheduleView(viewModel: .init(coordinator: .init()))
}
