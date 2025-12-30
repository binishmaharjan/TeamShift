import SwiftUI

// Modifier specifically for adding a custom close button (often for modals)
private struct CloseButtonModifier: ViewModifier {
    var closeButtonImage: Image
    var placement: ToolbarItemPlacement
    var onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: placement) {
                    Button {
                        onDismiss?()
                    } label: {
                        closeButtonImage
                            .renderingMode(.template)
                            .foregroundStyle(Color.appPrimary)
                    }
                }
            }
    }
}

extension View {
    /// Adds a custom close button to the toolbar, typically for modal views.
    /// - Parameters:
    ///   - image: The image to use for the close button. Defaults to "xmark".
    ///   - placement: The toolbar placement. Defaults to `.topBarTrailing`.
    ///   - action: An optional closure to run before dismissing.
    public func withCustomCloseButton(
        image: Image = .icnClose,
        placement: ToolbarItemPlacement = .topBarTrailing,
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(
            CloseButtonModifier(
                closeButtonImage: image,
                placement: placement,
                onDismiss: action
            )
        )
    }
}
