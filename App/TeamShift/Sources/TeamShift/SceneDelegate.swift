import UIKit

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    open var window: UIWindow?

    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("is this working")
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
