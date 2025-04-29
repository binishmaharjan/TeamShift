import Foundation
import SharedModels
import SwiftUI

@MainActor
public final class AuthenticationCoordinator: FlowCoordinator {
    // MARK: Init
    public init() {
        print("Start AuthenticationCoordinator")
    }
    
    deinit {
        print("Deinit AuthenticationCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public var finishDelegate: (any CoordinatorFinishDelegate)?
    public private(set) var startViewController = UIViewController()
    
    // MARK: Methods
    public func start() {
        let viewModel = OnboardingViewModel()
        let view = OnboardingView(coordinator: self, viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        startViewController = viewController
    }
}
