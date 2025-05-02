import Foundation
import SharedModels
import SharedUIs
import SwiftUI

public enum AuthenticationResult {
    case showMainTab
}

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
        return navigationController
    }()
    
    // MARK: Methods
    public func start() {
        let viewModel = OnboardingViewModel()
        viewModel.didRequestNavigation = { [weak self] route in
            self?.onboardingDidRequestNavigation(for: route)
        }
        let view = OnboardingView(viewModel: viewModel)
            .toolbar(.hidden)
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
        viewModel.didRequestFinish = { [weak self] result in
            self?.finish(with: result)
        }
        
        let view = CreateAccountView(viewModel: viewModel)
            .navigationBar()
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        startNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLoginView() {
        let viewModel = LoginViewModel()
        viewModel.didRequestFinish = { [weak self] result in
            self?.finish(with: result)
        }
        
        let view = LoginView(viewModel: viewModel)
            .navigationBar()
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        startNavigationController.pushViewController(viewController, animated: true)
    }
    
    func popLast() {
        startNavigationController.popViewController(animated: true)
    }
}
