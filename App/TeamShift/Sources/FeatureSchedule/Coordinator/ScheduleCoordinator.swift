import SharedModels
import SharedUIs
import SwiftUI

public enum ScheduleResult {
}

@MainActor
public final class ScheduleCoordinator: FlowCoordinator {
    public typealias ResultType = ScheduleResult

    // MARK: Init
    public init(navigationController: NavigationController) {
        print("ℹ️ \(Self.self): Start ScheduleCoordinator")
        startViewController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit ScheduleCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public  let startViewController: NavigationController
    
    private var navigationControllers = [NavigationController]()
    private var topNavigationController: NavigationController {
        navigationControllers.last ?? startViewController
    }
    private var rootNavigationController: NavigationController {
        navigationControllers.first ?? startViewController
    }
    
    public func start() {
        navigationControllers.append(startViewController)
        let viewModel = ScheduleViewModel(coordinator: self)
        let view = ScheduleView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        startViewController.setViewControllers([viewController], animated: false)
    }
}
