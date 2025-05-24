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
    public init(navigationController: UINavigationController) {
        print("ℹ️ \(Self.self): Start ProfileCoordinator")
        startNavigationController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit ProfileCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    private let startNavigationController: UINavigationController
    private var navigationControllers = [UINavigationController]()
    private var topNavigationController: UINavigationController {
        navigationControllers.last ?? startNavigationController
    }
    private var rootNavigationController: UINavigationController {
        navigationControllers.first ?? startNavigationController
    }
    
    public func start() {
        navigationControllers.append(startNavigationController)
        
        let viewModel = ProfileViewModel(coordinator: self)
        let view = ProfileView(viewModel: viewModel)
            .navigationBar("Me")
        
        let viewController = UIHostingController(rootView: view)
        startNavigationController.setViewControllers([viewController], animated: false)
    }
}

extension ProfileCoordinator {
    func profileRequestNavigation(for route: ProfileViewModel.Route) {
        switch route {
        case .showOnboarding:
            finish(with: .showOnboarding)
            
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
    
    private func pushChangePasswordView() {
        let viewModel = ChangePasswordViewModel(coordinator: self)
        
        let view = ChangePasswordView(viewModel: viewModel)
            .navigationBar("Change Password")
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLinkAccountView() {
        let viewModel = LinkAccountViewModel(coordinator: self)
        
        let view = LinkAccountView(viewModel: viewModel)
            .navigationBar()
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushDeleteAccountView() {
        let viewModel = DeleteAccountViewModel(coordinator: self)
        
        let view = DeleteAccountView(viewModel: viewModel)
            .navigationBar()
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
