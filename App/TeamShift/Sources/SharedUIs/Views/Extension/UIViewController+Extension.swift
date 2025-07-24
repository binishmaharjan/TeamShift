import UIKit

// MARK: Top Most ViewController
extension UIViewController {
    /// Top Most ViewController
    public var topMostViewController: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController ?? self
        }
        
        if let tabController = self as? UITabBarController {
            return tabController.selectedViewController?.topMostViewController ?? self
        }
        
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController
        }
        
        return self
    }
}
