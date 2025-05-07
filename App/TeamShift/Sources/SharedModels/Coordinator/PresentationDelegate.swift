import UIKit

public final class PresentationDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    public init(onInteractiveDismiss: @escaping () -> Void) {
        self.onInteractiveDismiss = onInteractiveDismiss
    }
    
    private let onInteractiveDismiss: () -> Void
    
    public func presentationControllerDidDismiss(
        _ presentationController: UIPresentationController
    ) {
        print("PresentedViewController was dismissed interactively by swipe down")
        onInteractiveDismiss()
    }
}
