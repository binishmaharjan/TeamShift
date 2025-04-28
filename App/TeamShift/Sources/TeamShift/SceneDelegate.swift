import SharedUIs
import SwiftUI
import UIKit

struct DummyView: View {
    var body: some View {
        Text("Hello World")
            .foregroundStyle(Color.accent)
    }
}

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    open var window: UIWindow?
    
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
        let viewController = UIHostingController(rootView: DummyView())
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
