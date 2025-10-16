import Foundation
import SharedModels
import SharedUIs
import SwiftUI

enum SplashResult {
    case showAuthentication
    case showMainTab
}

@MainActor
final class SplashCoordinator: FlowCoordinator {
    typealias ResultType = SplashResult
    
    // MARK: Init
    init() {
        print("ℹ️ \(Self.self): Start SplashCoordinator")
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit SplashCoordinator")
    }
    
    // MARK: Coordinator
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    var childCoordinator: (any Coordinator)?
    
    // MARK: Properties
    private(set) var startViewController = UIViewController()
    public var topMostViewController: UIViewController {
        startViewController.topMostViewController
    }
    
    // MARK: Methods
    func start() {
        let viewModel = SplashViewModel(coordinator: self)
        let view = SplashView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        startViewController = viewController
    }
}
