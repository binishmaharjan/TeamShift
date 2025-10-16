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
        GeometryReader { geometry in
            CustomRefreshView(scrollDelegate: scrollDelegate) {
                VStack {
                    emptyWorkplace(width: geometry.size.width, height: geometry.size.height)
                }
            } onRefresh: {
            }
        }
        .task {
            await viewModel.onViewAppear()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                addWorkplaceButton
            }
        }
        .safeAreaPadding(.top, 0)
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
    func emptyWorkplace(width: CGFloat, height: CGFloat) -> some View {
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
        .frame(width: width, height: height)
    }
}

#Preview {
    WorkplaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
