import SwiftUI

public struct CustomRefreshView<Content: View>: View {
    typealias Configuration = CustomRefreshViewModel.Configuration
    
    public init(
        scrollDelegate: CustomRefreshViewModel,
        showsScrollIndicators: Bool = false,
//        navigationHeight: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: @escaping () async -> Void
    ) {
        self.content = content()
        self.scrollDelegate = scrollDelegate
        self.showsScrollIndicators = showsScrollIndicators
//        self.navigationHeight = navigationHeight
        self.onRefresh = onRefresh
    }
    
    // MARK: Properties
    private var content: Content
    private var scrollDelegate: CustomRefreshViewModel
    private var showsScrollIndicators: Bool
//    private var navigationHeight: CGFloat
    private var onRefresh: () async -> Void
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsScrollIndicators) {
            VStack(spacing: 0) {
                content
                    .offset(y: Configuration.refreshTriggerOffset * scrollDelegate.progress)
            }
            .overlay {
                VStack(spacing: 0) {
                    // MARK: Adding a clear frame to avoid space from Custom Navigation Bar
//                    Color.clear.frame(height: navigationHeight)
                    
                    progressView
                    .scaleEffect(scrollDelegate.isEligible ? 1 : 0.001)
                    .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
                    .overlay {
                        arrowAndText
                        .opacity(scrollDelegate.isEligible ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
                    }
                    .frame(height: Configuration.refreshTriggerOffset * scrollDelegate.progress)
                    .frame(maxWidth: .infinity)
                    .opacity(scrollDelegate.progress)
                    .offset(
                        y: scrollDelegate.isEligible
                        ? -(scrollDelegate.contentOffset < 0 ? 0 : scrollDelegate.contentOffset)
                        : -(scrollDelegate.scrollOffset < 0 ? 0 : scrollDelegate.scrollOffset)
                    )
                    
                    Spacer()
                }
                .ignoresSafeArea(.all)
            }
            .offset(coordinateSpace: Configuration.scrollCoordinateSpace) { offset in
                // MARK: Storing Content Offset
                scrollDelegate.contentOffset = offset
                
                // MARK: Stopping the progress when its eligible for refresh
                if !scrollDelegate.isEligible {
                    var progress = offset / Configuration.refreshTriggerOffset
                    progress = (progress < 0 ? 0 : progress)
                    progress = (progress > 1 ? 1 : progress)
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    // MARK: haptic Feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .safeAreaPadding(.top, 0)
        .coordinateSpace(name: Configuration.scrollCoordinateSpace)
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { _, newValue in
            // MARK: Calling Async Method
            if newValue {
                Task {
                    // Wait for the duration the that takes time to execute onRefresh
                    await onRefresh()
                    // MARK: After Refresh, resetting the properties
                    withAnimation(.easeInOut(duration: 0.25)) {
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
}

// MARK: View Parts
extension CustomRefreshView {
    private var progressView: some View {
        VStack {
            ProgressView()
                .tint(Color.appPrimary)
            
            Text("Fetching Data..")
                .font(.caption.bold())
        }
        .foregroundStyle(Color.appPrimary)
    }
    
    private var arrowAndText: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down")
                .font(.caption.bold())
                .foregroundStyle(Color.white)
                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                .padding(8)
                .background(Color.appPrimary, in: Circle())
            
            Text("Pull To Refresh")
                .font(.caption.bold())
                .foregroundStyle(Color.appPrimary)
        }
    }
}
