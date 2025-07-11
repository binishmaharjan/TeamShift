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
        startNavigationController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit ProfileCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    private let startNavigationController: NavigationController
    private var navigationControllers = [NavigationController]()
    private var topNavigationController: NavigationController {
        navigationControllers.last ?? startNavigationController
    }
    private var rootNavigationController: NavigationController {
        navigationControllers.first ?? startNavigationController
    }
    
    public func start() {
        navigationControllers.append(startNavigationController)
        
        let viewModel = ProfileViewModel(coordinator: self)
        let view = ProfileView(viewModel: viewModel)
            .navigationBar(l10.profileNavTitle)
        
        let viewController = UIHostingController(rootView: view)
        startNavigationController.setViewControllers([viewController], animated: false)
    }
}

extension ProfileCoordinator {
    func profileRequestNavigation(for route: ProfileViewModel.Route) {
        switch route {
        case .showOnboarding:
            finish(with: .showOnboarding)
            
        case .showChangePicture:
            pushChangePictureView()
            
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
    
    private func pushChangePictureView() {
        let viewModel = ChangeAvatarViewModel(coordinator: self)
        
        let view = ChangeAvatarView(viewModel: viewModel)
            .navigationTitle("Change Picture")
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
            .navigationBar("Delete Account")
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
            .navigationBar()
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
}
