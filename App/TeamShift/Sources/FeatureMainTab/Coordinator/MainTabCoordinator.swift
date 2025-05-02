import SharedModels
import SharedUIs
import SwiftUI

public enum MainTabResult {
    case showAuthentication
}

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
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    // MARK: Properties
    public var startViewController = UIViewController()
    
    // MARK: Methods
    public func start() {
        let viewModel = MainTabViewModel()
        viewModel.didRequestFinish = { [weak self] result in
            self?.finish(with: result)
        }
        
        let view = MainTabView(viewModel: viewModel)
        let viewController = NamedUIHostingController(rootView: view)
        startViewController = viewController
    }
}
