import SwiftUI
import SharedModels
import SharedUIs

public enum MainTabResult { }

@MainActor
public final class MainTabCoordinator: CompositionCoordinator {
    public typealias ResultType = MainTabResult
    
    // MARK: Init
    public init() {
        print("\(Self.self): Start MainTabCoordinator")
    }
    
    deinit {
        print("\(Self.self): Deinit MainTabCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinators: [any Coordinator] = []
    public var finishDelegate: (any CoordinatorFinishDelegate)?
    // MARK: Properties
    public var startViewController = UIViewController()
    
    // MARK: Methods
    public func start() {
        let viewModel = MainTabViewModel()
        let view = MainTabView(viewModel: viewModel)
        let viewController = NamedUIHostingController(rootView: view)
        startViewController = viewController
    }
}
