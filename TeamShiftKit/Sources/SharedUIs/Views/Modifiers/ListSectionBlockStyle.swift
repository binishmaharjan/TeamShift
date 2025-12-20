import SwiftUI

private struct ListSectionBlockStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal, 15)
    }
}

extension View {
    public func listSectionBlockStyle() -> some View {
        modifier(ListSectionBlockStyle())
    }
}
