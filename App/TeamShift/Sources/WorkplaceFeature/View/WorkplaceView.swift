import SharedUIs
import SwiftUI

struct WorkplaceView: View {
    // MARK: Init
    init(viewModel: WorkplaceViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: WorkplaceViewModel
    
    private var scrollDelegate = CustomRefreshViewModel()
    
    var body: some View {
        CustomRefreshView(scrollDelegate: scrollDelegate) {
            VStack {
                emptyWorkplace
            }
        } onRefresh: {
        }
        .task {
            await viewModel.onViewAppear()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                addWorkplaceButton
            }
        }
        .safeAreaPadding(.top, 44)
        .loadingView(viewModel.isLoading)
        .background(Color.backgroundPrimary)
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
        GeometryReader { geometry in
            VStack {
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
            // Since CustomRefreshView is Scroll View and does not have
            // fixed height, so content cannot be centered. So, fetching the height and width from
            // geometry reader and setting it as VStack size
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    WorkplaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
