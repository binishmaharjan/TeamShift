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
    public let startViewController: NavigationController
    public var topMostViewController: UIViewController {
        navigationControllers.last?.topMostViewController ?? startViewController
    }
    
    private var navigationControllers = [NavigationController]()
    private var topNavigationController: NavigationController {
        navigationControllers.last ?? startViewController
    }
    
    public func start() {
        navigationControllers.append(startViewController)
        let viewModel = ScheduleViewModel(coordinator: self)
        let viewController = ScheduleViewController(viewModel: viewModel)
        startViewController.setViewControllers([viewController], animated: false)
    }
}
