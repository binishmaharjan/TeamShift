import SharedModels
import SharedUIs
import SwiftUI

public enum ProfileResult {
    case showOnboarding
}

@MainActor
public final class ProfileCoordinator: FlowCoordinator {
    public typealias ResultType = ProfileResult
    
    // MARK: Init
    public init(navigationController: NavigationController) {
        print("ℹ️ \(Self.self): Start ProfileCoordinator")
        startViewController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit ProfileCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public let startViewController: NavigationController
    public var topMostViewController: UIViewController {
        navigationControllers.last?.topMostViewController ?? startViewController
    }
    
    private var navigationControllers = [NavigationController]()
    private var topNavigationController: NavigationController {
        navigationControllers.last ?? startViewController
    }
    private var rootNavigationController: NavigationController {
        navigationControllers.first ?? startViewController
    }
    
    public func start() {
        navigationControllers.append(startViewController)
        
        let viewModel = ProfileViewModel(coordinator: self)
        let viewController = ProfileViewController(viewModel: viewModel)
        viewController.title = l10.profileNavTitle
        startViewController.setViewControllers([viewController], animated: false)
    }
}

// MARK: Profile Navigation
extension ProfileCoordinator {
    func profileRequestNavigation(for route: ProfileViewModel.Route) {
        switch route {
        case .showOnboarding:
            finish(with: .showOnboarding)
            
        case .showChangeAvatar:
            pushChangeAvatarView()
            
        case .showChangePassword:
            pushChangePasswordView()
            
        case .showLinkAccount:
            pushLinkAccountView()
            
        case .showDeleteAccount:
            pushDeleteAccountView()
            
        case .showStartWeekday:
            pushStartWeekDayView()
            
        case .showLicense:
            pushLicenseView()
        }
    }
    
    private func pushChangeAvatarView() {
        let viewModel = ChangeAvatarViewModel(coordinator: self)
        let viewController = ChangeAvatarViewController(viewModel: viewModel)
        viewController.title = l10.changeAvatarNavTitle
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushChangePasswordView() {
        let viewModel = ChangePasswordViewModel(coordinator: self)
        let viewController = ChangePasswordViewController(viewModel: viewModel)
        viewController.title = l10.changePasswordNavTitle
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLinkAccountView() {
        let viewModel = LinkAccountViewModel(coordinator: self)
        let view = LinkAccountView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.title = l10.linkAccountNavTitle
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushDeleteAccountView() {
        let viewModel = DeleteAccountViewModel(coordinator: self)
        let viewController = DeleteAccountViewController(viewModel: viewModel)
        viewController.title = l10.deleteAccountNavTitle
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushStartWeekDayView() {
        let viewModel = StartWeekDayViewModel(coordinator: self)
        let viewController = StartWeekDayViewController(viewModel: viewModel)
        viewController.title = ""
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLicenseView() {
        let viewModel = LicenseViewModel(coordinator: self)
        let viewController = LicenseViewController(viewModel: viewModel)
        viewController.title = l10.licenseNavTitle
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    func popLast() {
        topNavigationController.popViewController(animated: true)
    }
    
    func popToRoot() {
        topNavigationController.popToRootViewController(animated: true)
    }
    
    func signOutConfirmDialog(primaryAction: @escaping (() -> Void)) {
        topMostViewController.showConfirmationAlert(
            title: l10.profileAlertSignOutTitle,
            message: l10.profileAlertSignOutDescription,
            primaryTitle: l10.commonButtonOK,
            primaryAction: primaryAction
        )
    }
    
    func editNameDialog(primaryAction: @escaping ((String) -> Void)) {
        topMostViewController.showTextFieldAlert(
            title: l10.profileAlertChangeUsernameTitle,
            message: l10.profileAlertChangeUsernameDescription,
            textHint: l10.profileAlertChangeUsernameHint,
            primaryTitle: l10.commonButtonOK,
            primaryAction: primaryAction
        )
    }
}

// MARK: License Navigation
extension ProfileCoordinator {
    func pushLicenseDescription(licenseName: String, licenseText: String) {
        let view = LicenseDescriptionView(licenseText: licenseText)        
        let viewController = UIHostingController(rootView: view)
        viewController.title = licenseName
        topNavigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: Delete Navigation
extension ProfileCoordinator {
    func deleteConfirmDialog(primaryAction: @escaping (() -> Void)) {
        topMostViewController.showConfirmationAlert(
            title: l10.deleteAccountAlertConfirmTitle,
            message: l10.deleteAccountAlertConfirmMessage,
            primaryTitle: l10.deleteAccountAlertConfirmButtonTitle,
            primaryAction: primaryAction
        )
    }
}
