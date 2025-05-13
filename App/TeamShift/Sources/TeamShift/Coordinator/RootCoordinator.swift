import FeatureAuthentication
import FeatureMainTab
import SharedModels
import SharedUIs
import SwiftUI

@MainActor
final class RootCoordinator: CompositionCoordinator {
    typealias ResultType = Void
    
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
    
    func didFinish(childCoordinator: any Coordinator, with result: Any?) {
        if childCoordinator is SplashCoordinator, let splashResult = result as? SplashResult {
            switch splashResult {
            case .showAuthentication:
                startAuthentication()
                
            case .showMainTab:
                startMainTab()
            }
        }
        
        if childCoordinator is AuthenticationCoordinator, let authenticationResult = result as? AuthenticationResult {
            switch authenticationResult {
            case .showMainTab:
                startMainTab()
            }
        }
        
        if childCoordinator is MainTabCoordinator, let mainTabResult = result as? MainTabResult {
            switch mainTabResult {
            case .showAuthentication:
                startAuthentication()
            }
        }
        
        // Clean up
        removeChild(childCoordinator)
    }
}

extension RootCoordinator {
    private func startAuthentication() {
        let authenticationCoordinator = AuthenticationCoordinator()
        addChild(authenticationCoordinator)
        authenticationCoordinator.start()
        startViewController.replace(authenticationCoordinator.startNavigationController, animated: true)
    }
    
    private func startMainTab() {
        let mainTabCoordinator = MainTabCoordinator()
        addChild(mainTabCoordinator)
        mainTabCoordinator.start()
        startViewController.replace(mainTabCoordinator.tabViewController, animated: true)
    }
}
