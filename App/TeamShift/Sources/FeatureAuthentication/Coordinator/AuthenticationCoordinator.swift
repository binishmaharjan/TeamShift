import Foundation
import SharedModels
import SharedUIs
import SwiftUI

public enum AuthenticationResult { }

@MainActor
public final class AuthenticationCoordinator: FlowCoordinator {
    public typealias ResultType = AuthenticationResult
    
    // MARK: Init
    public init() {
        print("\(Self.self): Start AuthenticationCoordinator")
    }
    
    deinit {
        print("\(Self.self): Deinit AuthenticationCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public lazy var startNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        // Configure appearance if needed
        // navigationController.navigationItem.largeTitleDisplayMode = .never
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    // MARK: Methods
    public func start() {
        let viewModel = OnboardingViewModel()
        viewModel.didRequestNavigation = { [weak self] route in
            self?.onboardingDidRequestNavigation(for: route)
        }
        let view = OnboardingView(viewModel: viewModel)
        let viewController = NamedUIHostingController(rootView: view)
        startNavigationController.setViewControllers([viewController], animated: false) 
    }
}

// MARK: Navigation
extension AuthenticationCoordinator {
    func onboardingDidRequestNavigation(for route: OnboardingViewModel.Route) {
        switch route {
        case .createAccount:
            pushCreateAccountView()
            
        case .login:
            pushLoginView()
        }
    }
    
    private func pushCreateAccountView() {
        let viewModel = CreateAccountViewModel()
        let view = CreateAccountView(viewModel: viewModel)
        let viewController = NamedUIHostingController(rootView: view)
        startNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLoginView() {
        let viewModel = LoginViewModel()
        let view = LoginView(viewModel: viewModel)
        let viewController = NamedUIHostingController(rootView: view)
        startNavigationController.pushViewController(viewController, animated: true)
    }
    
    func popLast() {
        startNavigationController.popViewController(animated: true)
    }
}

