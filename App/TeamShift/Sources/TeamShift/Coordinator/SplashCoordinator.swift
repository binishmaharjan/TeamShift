import Foundation
import SharedModels
import SwiftUI

@MainActor
final class SplashCoordinator: FlowCoordinator {
    // MARK: Init
    init() {
        print("Start SplashCoordinator")
    }
    
    deinit {
        print("Deinit SplashCoordinator")
    }
    
    // MARK: Coordinator
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    var childCoordinator: Coordinator?
    
    // MARK: Properties
    private(set) var startViewController = UIViewController()
    
    // MARK: Methods
    func start() {
        let viewModel = SplashViewModel()
        let view = SplashView(coordinator: self, viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        startViewController = viewController
    }
}

// MARK: Navigation
extension SplashCoordinator {
}
