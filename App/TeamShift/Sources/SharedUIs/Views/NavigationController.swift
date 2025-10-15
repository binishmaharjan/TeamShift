import UIKit

/**
 * Custom NavigationController that provides consistent navigation bar styling across the app.
 * Configures transparent background, custom back button image, and removes back button text.
 */
public class NavigationController: UINavigationController {
    /// Called after the controller's view is loaded into memory
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

// MARK: - Navigation Bar Configuration
extension NavigationController {
    /**
     * Configures the navigation bar appearance with custom styling
     * - Sets transparent background
     * - Applies custom back button image from shared UI bundle
     * - Sets primary app color as tint color
     * - Removes back button text for cleaner appearance
     */
    private func setupNavigationBar() {
        // Disable large titles for consistent inline appearance
        navigationBar.prefersLargeTitles = false
        
        // Create and configure transparent navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Load custom back button image from shared UI bundle with template rendering
        // Template rendering allows the image to respect tint color changes
        let backImage = UIImage(named: "icn_back", in: Bundle.sharedUIs, with: nil)?.withRenderingMode(.alwaysTemplate)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        // Apply appearance to all navigation bar states
        navigationBar.standardAppearance = appearance        // Normal height navigation bar
        navigationBar.scrollEdgeAppearance = appearance      // Navigation bar when content is at top
        navigationBar.compactAppearance = appearance         // Compact height navigation bar (landscape)
        
        // Set tint color for navigation bar items (back button, bar button items)
        navigationBar.tintColor = UIColor(named: "app_primary", in: Bundle.sharedUIs, compatibleWith: nil)
        navigationBar.barTintColor = UIColor(named: "app_primary", in: Bundle.sharedUIs, compatibleWith: nil)
        
        // Remove back button text to show only the custom icon
        navigationBar.topItem?.backButtonTitle = ""
    }
}
