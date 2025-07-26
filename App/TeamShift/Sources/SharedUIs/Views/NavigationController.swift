import UIKit

public class NavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

extension NavigationController {
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        // Always use inline title style
        navigationBar.prefersLargeTitles = false
        
        // Customize navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = UIColor.separator
        
        // Set title text attributes
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        
//        navigationBar.standardAppearance = appearance
//        navigationBar.scrollEdgeAppearance = appearance
//        navigationBar.compactAppearance = appearance
        
        // Hide default back button
        navigationBar.topItem?.hidesBackButton = true
    }
}
