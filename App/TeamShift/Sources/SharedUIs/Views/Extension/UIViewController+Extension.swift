import SharedModels
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

// MARK: Alert
public struct AlertAction {
    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    public let title: String
    public let style: UIAlertAction.Style
    public let handler: (() -> Void)?
}

extension UIViewController {
    public func showAlert(title: String?, message: String?, actions: [AlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for alertAction in actions {
            let action = UIAlertAction(
                title: alertAction.title,
                style: alertAction.style
            ) { _ in alertAction.handler?() }
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
    
    public func showConfirmationAlert(
        title: String?,
        message: String?,
        primaryTitle: String = l10.commonButtonConfirm,
        secondaryTitle: String = l10.commonButtonCancel,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        let actions = [
            AlertAction(title: secondaryTitle, style: .cancel, handler: secondaryAction),
            AlertAction(title: primaryTitle, style: .default, handler: primaryAction)
        ]
        
        showAlert(title: title, message: message, actions: actions)
    }
    
    public func showTextFieldAlert(
        title: String?,
        message: String?,
        textHint: String,
        primaryTitle: String = l10.commonButtonConfirm,
        secondaryTitle: String = l10.commonButtonCancel,
        primaryAction: @escaping (String) -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        let primaryButton = UIAlertAction(title: primaryTitle, style: .default) { _ in
            let input = alert.textFields?[0].text ?? ""
            primaryAction(input)
        }
        let secondaryButton = UIAlertAction(title: secondaryTitle, style: .cancel) { _ in
            secondaryAction?()
        }
        alert.addAction(primaryButton)
        alert.addAction(secondaryButton)
        
        present(alert, animated: true)
    }
}

extension Coordinator {
    public func handleError(_ error: Error) {
        guard let error = error as? AppError else {
            showErrorAlert(l10.commonAlertError)
            return
        }
        
        switch error {
        case .apiError(let apiError):
            showErrorAlert(apiError.localizedDescription)
            
        case .internalError(let internalError):
            showErrorAlert(internalError.localizedDescription)
            
        case .unknown:
            showErrorAlert(error.localizedDescription)
        }
    }
    
    public func showSuccessAlert(title: String = l10.commonAlertSuccess, message: String, completion: (() -> Void)? = nil) {
        let actions = [
            AlertAction(title: l10.commonButtonOK, style: .default, handler: completion)
        ]
        topMostViewController.showAlert(
            title: title,
            message: message,
            actions: actions
        )
    }
    
    private func showErrorAlert(_ errorMessage: String, completion: (() -> Void)? = nil) {
        topMostViewController.showAlert(
            title: l10.commonAlertError,
            message: errorMessage,
            actions: [
                AlertAction(title: l10.commonButtonOK, style: .default, handler: completion)
            ]
        )
    }
}
