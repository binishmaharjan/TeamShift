import SwiftUI

/// Custom Transparent Navigation Bar
private struct NavigationBar: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .toolbar(.visible)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.titleTextAttributes = [.foregroundColor: UIColor(.appPrimary)]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.appPrimary)]
                appearance.configureWithTransparentBackground()
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}

extension View {
    public func navigationBar(_ title: String = "") -> some View {
        modifier(NavigationBar(title: title))
    }
}
