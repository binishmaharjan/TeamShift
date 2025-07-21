import SharedModels
import SharedUIs
import SwiftUI

public enum WorkplaceResult {
}

@MainActor
public final class WorkplaceCoordinator: FlowCoordinator {
    public typealias ResultType = WorkplaceResult
    
    // MARK: Init
    public init(navigationController: NavigationController) {
        print("ℹ️ \(Self.self): Start WorkplaceCoordinator")
        startNavigationController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit WorkplaceCoordinator")
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
        
        let viewModel = WorkplaceViewModel(coordinator: self)
        let view = WorkplaceView(viewModel: viewModel)
            .navigationBar(l10.workplaceNavTitle)
        
        let viewController = UIHostingController(rootView: view)
        startNavigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: Navigation
extension WorkplaceCoordinator {
    func workplaceRequestNavigation(for route: WorkplaceViewModel.Route) {
        switch route {
        case .showAddWorkplace:
            pushAddWorkplaceView()
        }
    }
    
    private func pushAddWorkplaceView() {
        let viewModel = AddWorkplaceViewModel(coordinator: self)
        
        let view = AddWorkplaceView(viewModel: viewModel)
            .navigationBar("Add Workplace")
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        topNavigationController.pushViewController(viewController, animated: true)
    }
}
