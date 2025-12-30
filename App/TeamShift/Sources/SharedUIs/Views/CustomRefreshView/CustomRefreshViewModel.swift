import CoreGraphics
import Foundation
import UIKit

/**
 Note: If CustomRefreshViewModel is hold by CustomRefreshView,
 then the customRefreshViewModel state is reset when TCA(or View) state is also changed.
 So create a static instance in each view to prevent CustomRefreshViewModel state from changing unexpectedly.
 */
@Observable @MainActor
public final class CustomRefreshViewModel: NSObject, UIGestureRecognizerDelegate {
    enum Configuration {
        static let refreshTriggerOffset: CGFloat = 75
        static let scrollCoordinateSpace: String = UUID().uuidString
    }
    
    // MARK: Properties
    var isEligible = false
    var isRefreshing = false
    // MARK: Offset And Progress
    var scrollOffset: CGFloat = 0
    var contentOffset: CGFloat = 0
    var progress: CGFloat = 0
    let gestureID = UUID().uuidString
    
    // Since we need to know when user left the screen to start refresh
    // Adding pan gesture to ui main application window
    // with Simultaneous Gesture
    // Thus it wont disturb the SwiftUI scroll and gesture
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    // MARK: Adding gesture
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChanged(gesture:)))
        panGesture.delegate = self
        panGesture.name = gestureID
        rootViewController().view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Removing Gesture When Leaving the view
    func removeGesture() {
        rootViewController().view.gestureRecognizers?.removeAll { gesture in
            gesture.name == gestureID
        }
    }
    
    // MARK: Root View
    func rootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIViewController()
        }
        
        guard let rootView = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        
        return rootView
    }
    
    @objc func onGestureChanged(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            // MARK: Max Scroll Offset
            if !isRefreshing {
                if scrollOffset > Configuration.refreshTriggerOffset {
                    isEligible = true
                } else {
                    isEligible = false
                }
            }
        }
    }
}
