import UIKit
import SharedUIs

open class AppDelegate: UIResponder, UIApplicationDelegate {
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // custom fonts
        CustomFontManager.registerFonts()
        
        return true
    }
}
