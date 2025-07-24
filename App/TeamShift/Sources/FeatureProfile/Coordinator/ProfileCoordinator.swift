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
    public  let startViewController: NavigationController
    
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
        let view = ProfileView(viewModel: viewModel)
            .navigationBar(l10.profileNavTitle)
        
        let viewController = UIHostingController(rootView: view)
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
        
        let view = ChangeAvatarView(viewModel: viewModel)
            .navigationTitle(l10.changeAvatarNavTitle)
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushChangePasswordView() {
        let viewModel = ChangePasswordViewModel(coordinator: self)
        
        let view = ChangePasswordView(viewModel: viewModel)
            .navigationBar(l10.changePasswordNavTitle)
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLinkAccountView() {
        let viewModel = LinkAccountViewModel(coordinator: self)
        
        let view = LinkAccountView(viewModel: viewModel)
            .navigationBar(l10.linkAccountNavTitle)
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushDeleteAccountView() {
        let viewModel = DeleteAccountViewModel(coordinator: self)
        
        let view = DeleteAccountView(viewModel: viewModel)
            .navigationBar(l10.deleteAccountNavTitle)
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushStartWeekDayView() {
        let viewModel = StartWeekDayViewModel(coordinator: self)
        
        let view = StartWeekDayView(viewModel: viewModel)
            .navigationBar()
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLicenseView() {
        let viewModel = LicenseViewModel(coordinator: self)
        
        let view = LicenseView(viewModel: viewModel)
            .navigationBar(l10.licenseNavTitle)
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    func popLast() {
        topNavigationController.popViewController(animated: true)
    }
    
    func popToRoot() {
        topNavigationController.popToRootViewController(animated: true)
    }
}

// MARK: License Navigation
extension ProfileCoordinator {
    func pushLicenseDescription(licenseName: String, licenseText: String) {
        let view = LicenseDescriptionView(licenseText: licenseText)
            .navigationBar(licenseName)
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
}
