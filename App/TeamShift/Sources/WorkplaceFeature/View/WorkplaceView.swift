import SharedUIs
import SwiftUI

struct WorkplaceView: View {
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
        .task {
            await viewModel.onViewAppear()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                addWorkplaceButton
            }
        }
        .loadingView(viewModel.isLoading)
        .background(Color.backgroundPrimary)
        .padding(.horizontal, 24)
    }
}

// MARK: Views
extension WorkplaceView {
    @ViewBuilder
    private var addWorkplaceButton: some View {
        Button {
            viewModel.addWorkplaceButtonTapped()
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
    }
}

#Preview {
    WorkplaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
