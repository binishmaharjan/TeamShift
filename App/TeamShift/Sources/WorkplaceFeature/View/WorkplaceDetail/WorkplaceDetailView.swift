
import SwiftUI
import SharedModels

struct WorkplaceDetailView: View {
    @State var viewModel: WorkplaceDetailViewModel

    var body: some View {
        Text("Workplace Detail for \(viewModel.workplace.name)")
            .navigationTitle("Workplace Details")
    }
}
