import SwiftUI

/// Custom Transparent Navigation Bar
private struct NavigationBar: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .toolbar(.visible)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    public func navigationBar(_ title: String = "") -> some View {
        modifier(NavigationBar(title: title))
    }
}
