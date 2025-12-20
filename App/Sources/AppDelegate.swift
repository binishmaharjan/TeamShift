import UIKit
import TeamShiftKit

@main
class AppDelegate: TeamShiftKit.AppDelegate {
    override func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        
        // 1. Get Base Config
        let config = super.application(application, configurationForConnecting: connectingSceneSession, options: options)
        
        // 2. FORCE Local Connection
        config.delegateClass = SceneDelegate.self
        
        return config
    }
}
