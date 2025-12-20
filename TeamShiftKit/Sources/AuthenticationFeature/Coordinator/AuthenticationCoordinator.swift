import Foundation
import SharedModels
import SharedUIs
import SwiftUI
import UIKit

public enum AuthenticationResult {
    case showMainTab
}

@MainActor
public final class AuthenticationCoordinator: FlowCoordinator {
    public typealias ResultType = AuthenticationResult
    
    // MARK: Init
    public init() {
        print("ℹ️ \(Self.self): Start AuthenticationCoordinator")
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit AuthenticationCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public lazy var startViewController: NavigationController = {
        let navigationController = NavigationController()
        return navigationController
    }()
    public var topMostViewController: UIViewController {
        navigationControllers.last?.topMostViewController ?? startViewController
    }
    
    private var navigationControllers = [NavigationController]()
    private var topNavigationController: NavigationController {
        navigationControllers.last ?? startViewController
    }
    private var routePresentationDelegates: [PresentationDelegate] = []
    
    // MARK: Methods
    public func start() {
        let viewModel = OnboardingViewModel(coordinator: self)
        let viewController = OnboardingViewController(viewModel: viewModel)
        navigationControllers.append(startViewController)
        startViewController.setViewControllers([viewController], animated: false)
    }
}

// MARK: Onboarding Navigation
extension AuthenticationCoordinator {
    func onboardingRequestNavigation(for route: OnboardingViewModel.Route) {
        switch route {
        case .createAccount:
            pushCreateAccountView()
            
        case .login:
            pushLoginView()
        }
    }
    
    func continueAsGuestConfirmDialog(primaryAction: @escaping (() -> Void)) {
        topMostViewController.showConfirmationAlert(
            title: l10.onboardingAlertGuestUserTitle,
            message: l10.onboardingAlertGuestUserDescription,
            primaryTitle: l10.onboardingAlertGuestUserButton,
            primaryAction: primaryAction
        )
    }
    
    private func pushCreateAccountView() {
        let viewModel = CreateAccountViewModel(coordinator: self)
        let viewController = CreateAccountViewController(viewModel: viewModel)
        viewController.title = l10.onboardingTitle
        startViewController.pushViewController(viewController, animated: true)
    }
    
    private func pushLoginView() {
        let viewModel = SignInViewModel(coordinator: self)
        let viewController = SignInViewController(viewModel: viewModel)
        viewController.title = l10.signInTitle
        startViewController.pushViewController(viewController, animated: true)
    }
    
    func popLast() {
        startViewController.popViewController(animated: true)
    }
}

// MARK: SignIn Navigvation
extension AuthenticationCoordinator {
    func signInRequestNavigation(for route: SignInViewModel.Route) {
        switch route {
        case .forgotPassword:
            presentForgotPasswordView()
        }
    }
    
    private func presentForgotPasswordView() {
        let navigationController = NavigationController()
        
        let viewModel = ForgotPasswordViewModel(coordinator: self)
        let viewController = ForgotPasswordViewController(viewModel: viewModel) { [weak navigationController, weak self] in
            navigationController?.dismiss(animated: true)
            if let presentedNavigationController = navigationController {
                self?.navigationControllers.removeAll { $0 === presentedNavigationController }
                self?.routePresentationDelegates.removeLast()
            }
        }
        viewController.title = l10.forgotPasswordTitle
        navigationController.setViewControllers([viewController], animated: false)
        navigationControllers.append(navigationController)
        
        // For Swipe Down
        let presentationDelegate = PresentationDelegate { [weak self] in
            self?.navigationControllers.removeLast()
            self?.routePresentationDelegates.removeLast()
        }
        navigationController.presentationController?.delegate = presentationDelegate
        routePresentationDelegates.append(presentationDelegate)
        
        startViewController.present(navigationController, animated: true)
    }
}
