import SwiftUI

// Modifier specifically for adding a custom close button (often for navigation)
private struct BackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButtonImage: Image
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        backButtonImage
                            .renderingMode(.template)
                            .foregroundStyle(Color.appPrimary)
                    }
                }
            }
    }
}

extension View {
    /// Adds a custom back button to the toolbar, typically for navigation views.
    /// - Parameters:
    ///   - image: The image to use for the back button. Defaults to "back arrow".
    public func withCustomBackButton(image: Image = .icnBack) -> some View {
        modifier(BackButtonModifier(backButtonImage: image))
    }
}
