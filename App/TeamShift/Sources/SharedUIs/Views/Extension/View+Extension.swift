import SwiftUI

extension View {
    /// horizontal spacer
    @ViewBuilder
    public func hSpacing(_ alignment: Alignment) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
    
    /// vertical spacer
    @ViewBuilder
    public func vSpacing(_ alignment: Alignment) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// horizontal separator
    @ViewBuilder
    public func hSeparator() -> some View {
        Rectangle()
            .fill(Color.backgroundSeparator.opacity(0.5))
            .frame(height: 1)
    }
    
    /// vertical separator
    @ViewBuilder
    public func vSeparator() -> some View {
        Rectangle()
            .fill(Color.backgroundSeparator.opacity(0.5))
            .frame(width: 1)
    }
}

// MARK: Offset Modifier(For CustomRefreshView)
extension View {
    @ViewBuilder
    public func offset(coordinateSpace: String, offset: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        offset(value)
                    }
            }
        }
    }
}
