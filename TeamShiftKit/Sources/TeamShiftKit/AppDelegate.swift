import FirebaseCore
import SharedModels
import SharedUIs
import UIKit

open class AppDelegate: UIResponder, UIApplicationDelegate {
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // custom fonts
        CustomFontManager.registerFonts()
        // Setup Firebase
        setupFirebaseServer()
        
        return true
    }
    
    // This base configuration points to the Package's SceneDelegate by default
    open func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

// MARK: Firebase
extension AppDelegate {
    private func setupFirebaseServer() {
        FirebaseApp.configure()
    }
}
