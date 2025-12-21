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
                try? await Task.sleep(for: .seconds(0.5))
                await viewModel.send(action: .onPullToRefresh)
            }
        }
        .loadingView(viewModel.isLoading)
    }
}

// MARK: Views
extension WorkplaceView {
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
        .frame(width: (width - 32), height: height)
        .padding(.horizontal, 16)
    }
}

#Preview {
    WorkplaceView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
