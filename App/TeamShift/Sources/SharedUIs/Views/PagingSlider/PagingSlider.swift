import SwiftUI

/// Link: https://www.youtube.com/watch?v=IK8yQMeyhs4&t=37s

/// Paging Slider Data Model - Defines the structure for each item in the slider
public struct Item: Identifiable {
    public init(id: UUID = UUID(), color: Color, title: String, subTitle: String) {
        self.id = id
        self.color = color
        self.title = title
        self.subTitle = subTitle
    }
    
    public var id = UUID()
    public var color: Color
    public var title: String
    public var subTitle: String
}

/// UIKit-based page control wrapper for SwiftUI
/// Uses @MainActor to ensure UI operations happen on the main thread
@MainActor
struct PagingControl: UIViewRepresentable {
    /// Coordinator class to handle communication between UIKit and SwiftUI
    @MainActor
    class Coordinator: NSObject {
        init(onPageChange: @escaping (Int) -> Void) {
            self.onPageChange = onPageChange
        }
        
        var onPageChange: (Int) -> Void
        
        /// Called when user interacts with the UIPageControl
        @objc func onPageUpdate(control: UIPageControl) {
            onPageChange(control.currentPage)
        }
    }
    
    var numberOfPage: Int
    var activePage: Int
    var onPageChange: (Int) -> Void
    
    /// Creates the UIPageControl instance
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.currentPage = activePage
        view.numberOfPages = numberOfPage
//        view.backgroundStyle = .prominent
        view.currentPageIndicatorTintColor = UIColor(Color.appPrimary)
        view.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
        view.pageIndicatorTintColor = UIColor.placeholderText
        return view
    }
    
    /// Updates the UIPageControl when SwiftUI state changes
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        // updating outside event change
        uiView.numberOfPages = numberOfPage
        uiView.currentPage = activePage
    }
    
    /// Creates the coordinator to handle events
    func makeCoordinator() -> Coordinator {
        Coordinator(onPageChange: onPageChange)
    }
}

/// A customizable paging slider component that displays items with scrollable content and titles
/// Uses @MainActor to ensure UI operations happen on the main thread
@MainActor
public struct PagingSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
    /// Initialize the paging slider with data and view builders
    public init(
        data: Binding<Item>,
        content: @escaping (Binding<Item.Element>) -> Content,
        titleContent: @escaping (Binding<Item.Element>) -> TitleContent
    ) {
        self._data = data
        self.content = content
        self.titleContent = titleContent
    }
    // MARK: Properties
    /// Controls whether scroll indicators are shown
    var showsIndicator: ScrollIndicatorVisibility = .hidden
    /// Controls whether the paging control dots are shown
    var showPagingControl = true
    /// Controls how fast the title scrolls relative to content (parallax effect)
    var titleScrollSpeed: CGFloat = 0.6
    /// Spacing between the content and paging control
    var pagingControlSpacing: CGFloat = 10
    /// Horizontal spacing between slider items
    var spacing: CGFloat = 10
    
    /// Collection of items to display in the slider
    @Binding var data: Item
    /// Builder for the main content of each item
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    /// Builder for the title section of each item
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    
    /// Tracks the currently active/visible item
    @State private var activeID: UUID?
    
    public var body: some View {
        VStack(spacing: pagingControlSpacing) {
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach($data) { item in
                        VStack(spacing: 0) {
                            titleContent(item)
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, proxy in
                                    // calculate the scroll offset of title to create parallax effect
                                    // this creates a subtle parallax scrolling effect for titles
                                    let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
                                    let scrollOffset = -minX * min(titleScrollSpeed, 1.0)
                                    
                                    return content.offset(x: scrollOffset)
                                }
                            
                            content(item)
                        }
                        .containerRelativeFrame(.horizontal)  // makes each item take full width of container
                    }
                }
                // configure the scroll view for paging behavior
                .scrollTargetLayout()
            }
            // Control visibility of scroll indicators
            .scrollIndicators(showsIndicator)
            // Ensures items snap to alignment
            .scrollTargetBehavior(.viewAligned)
            // Tracks the current scroll position by ID
            .scrollPosition(id: $activeID)
            
            // Add the paging indicator dots at the bottom
            PagingControl(numberOfPage: data.count, activePage: activePage) { value in
                // Handler for when user taps a different page indicator
                if let index = value as? Item.Index, data.indices.contains(index) {
                    if let id = data[index].id as? UUID {
                        // Animate to the selected page
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                            activeID = id
                        }
                    }
                }
            }
        }
    }
    
    /// Computed property to determine the currently active page index
    var activePage: Int {
        if let index = data.firstIndex(where: { $0.id as? UUID == activeID }) as? Int {
            return index
        }
        
        // Default to first page if no match is found
        return 0
    }
}
