import SharedModels
import SharedUIs
import SwiftUI

public enum ProfileResult {
}

@MainActor
public final class ProfileCoordinator: FlowCoordinator {
    public typealias ResultType = ProfileResult
    
    // MARK: Init
    public init(navigationController: UINavigationController) {
        print("\(Self.self): Start ProfileCoordinator")
        startNavigationController = navigationController
    }
    
    deinit {
        print("\(Self.self): Deinit ProfileCoordinator")
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
        let view = ProfilView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        startNavigationController.setViewControllers([viewController], animated: false)
    }
}
