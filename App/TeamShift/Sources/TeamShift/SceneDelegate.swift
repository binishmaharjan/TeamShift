import SharedUIs
import SwiftUI
import UIKit

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    open var window: UIWindow?
    private var rootCoordinator: RootCoordinator?
    
    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setup(scene: scene)
    }
}

// MARK: Setup
extension SceneDelegate {
    private func setup(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window else { return }
        let rootCoordinator = RootCoordinator()
        rootCoordinator.start()
        window.rootViewController = rootCoordinator.startViewController
        window.makeKeyAndVisible()
        self.rootCoordinator = rootCoordinator
        
    }
}
