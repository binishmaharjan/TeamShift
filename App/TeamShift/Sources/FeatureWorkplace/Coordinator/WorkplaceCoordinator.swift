import SharedModels
import SharedUIs
import SwiftUI

public enum WorkplaceResult {
}

@MainActor
public final class WorkplaceCoordinator: FlowCoordinator {
    public typealias ResultType = WorkplaceResult
    
    // MARK: Init
    public init(navigationController: UINavigationController) {
        print("\(Self.self): Start WorkplaceCoordinator")
        startNavigationController = navigationController
    }
    
    deinit {
        print("\(Self.self): Deinit WorkplaceCoordinator")
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
        let viewModel = WorkplaceViewModel(coordinator: self)
        let view = WorkPlaceView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        startNavigationController.setViewControllers([viewController], animated: false)
    }
}
