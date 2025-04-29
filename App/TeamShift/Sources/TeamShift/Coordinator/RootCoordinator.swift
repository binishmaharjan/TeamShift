import SharedModels
import SharedUIs
import SwiftUI

@MainActor
final class RootCoordinator: CompositionCoordinator {
    // MARK: Child Coordinator
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    var childCoordinators = [any Coordinator]()
    
    // MARK: Properties
    var startViewController = SingleContainerViewContainer()
    
    // MARK: Methods
    func start() {
        let splashCoordinator = SplashCoordinator()
        addChild(splashCoordinator)
        splashCoordinator.start()
        
        // add splash as child
        startViewController.replace(splashCoordinator.startViewController, animated: false)
    }
    
    func didFinish(childCoordinator: any Coordinator) {
    }
}
