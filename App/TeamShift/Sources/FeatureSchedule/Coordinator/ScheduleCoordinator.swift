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
        startNavigationController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit ScheduleCoordinator")
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
        let viewModel = ScheduleViewModel(coordinator: self)
        let view = ScheduleView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        startNavigationController.setViewControllers([viewController], animated: false)
    }
}
