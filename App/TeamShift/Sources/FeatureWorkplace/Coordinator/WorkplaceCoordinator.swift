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
        startViewController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit WorkplaceCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public  let startViewController: NavigationController
    public var topMostViewController: UIViewController {
        navigationControllers.last?.topMostViewController ?? startViewController
    }
    
    private var navigationControllers = [NavigationController]()
    private var topNavigationController: NavigationController {
        navigationControllers.last ?? startViewController
    }
    private var rootNavigationController: NavigationController {
        navigationControllers.first ?? startViewController
    }
    
    public func start() {
        navigationControllers.append(startViewController)
        
        let viewModel = WorkplaceViewModel(coordinator: self)
        let view = WorkplaceView(viewModel: viewModel)
            .navigationBar(l10.workplaceNavTitle)
        
        let viewController = UIHostingController(rootView: view)
        startViewController.setViewControllers([viewController], animated: false)
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
