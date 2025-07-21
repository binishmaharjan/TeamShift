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
            emptyWorkplace
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                addWorkplaceButton
            }
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: Views
extension WorkPlaceView {
    @ViewBuilder
    private var addWorkplaceButton: some View {
        Button {
            print("Add Workplace")
        } label: {
            Image.icnStoreAdd
                .renderingMode(.template)
                .foregroundStyle(Color.appPrimary)
        }
        .buttonStyle(.toolbar)
    }
    
    @ViewBuilder
    private var emptyWorkplace: some View {
        Image.icnStore
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 64, height: 64)
            .foregroundStyle(Color.textSecondary)
        
        Text(l10.workplaceEmptyTitle)
            .font(.customHeadline)
            .foregroundStyle(Color.textSecondary)
        
        Text(l10.workplaceEmptyDescription)
            .font(.customCaption)
            .foregroundStyle(Color.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }
}

#Preview {
    WorkPlaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
