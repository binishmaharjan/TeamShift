import SharedModels
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
                    switch viewModel.workplaces {
                    case .none:
                        EmptyView()
                        
                    case .some(let workplaces) where workplaces .isEmpty:
                        emptyWorkplace(width: geometry.size.width, height: geometry.size.height)
                        
                    case .some(let workplaces):
                        VStack(spacing: 16) {
                            ForEach(workplaces, id: \.id) { workplace in
                                workplaceItem(for: workplace)
                            }
                        }
                    }
                }

            } onRefresh: {
                try? await Task.sleep(for: .seconds(0.5))
                await viewModel.send(action: .onPullToRefresh)
            }
        }
        .loadingView(viewModel.isLoading)
        .background(Color.backgroundList)
    }
}

// MARK: Views
extension WorkplaceView {
    @ViewBuilder
    private func emptyWorkplace(width: CGFloat, height: CGFloat) -> some View {
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
    
    @ViewBuilder
    private func workplaceItem(for workplace: Workplace) -> some View {
        HStack(spacing: 8) {
            Image.icnStore.renderingMode(.template)
                .foregroundStyle(Color.appPrimary)
                .frame(width: 32, height: 32)
                .padding()
                .background(Color.backgroundList.opacity(0.8))
                .cornerRadius(8)
            
            VStack {
                Text(workplace.name)
                    .font(.customSubHeadline)
                    .foregroundStyle(Color.textPrimary)
                    .hSpacing(.leading)
                
                Text(workplace.branchName ?? "")
                    .font(.customFootnote)
                    .foregroundStyle(Color.textPrimary)
                    .hSpacing(.leading)
                
                HStack {
                    Text("Members: 0")
                        .font(.customCaption)
                        .foregroundStyle(Color.textSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .overlay {
                            Capsule()
                                .stroke(Color.textSecondary, lineWidth: 1)
                        }
                }
                .hSpacing(.leading)
            }
            .vSpacing(.top)
            
        }
        .hSpacing(.leading)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.backgroundPrimary)
        .cornerRadius(16)
        .shadow(color: Color.textPrimary.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.workplaceRowTapped(workplace)
        }
    }
}

#Preview {
    let viewModel = WorkplaceViewModel()
    viewModel.workplaces = [.mockData]
    return WorkplaceView(viewModel: viewModel)
}
