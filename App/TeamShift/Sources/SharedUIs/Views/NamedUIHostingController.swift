import SwiftUI

/**
 * NamedUIHostingController
 *
 * A custom UIHostingController subclass that provides a meaningful name
 * in Xcode's View Hierarchy debugger. This helps distinguish between
 * multiple SwiftUI hosting controllers during debugging sessions.
 *
 * Usage:
 * ```
 * // Instead of standard UIHostingController
 * // let controller = UIHostingController(rootView: MyView())
 *
 * // Use NamedUIHostingController with a descriptive name
 * let controller = NamedUIHostingController(
 *     viewHierarchyName: "ProfileScreen",
 *     rootView: ProfileView()
 * )
 * ```
 */
public class NamedUIHostingController<Content: View>: UIHostingController<Content> {
    /**
     * Creates a new hosting controller with a custom display name for the view hierarchy
     *
     * - Parameters:
     *   - viewHierarchyName: The name that will be displayed in Xcode's View Hierarchy debugger
     *   - rootView: The SwiftUI view to host
     */
    override public init(rootView: Content) {
        self.viewHierarchyName = String(describing: Content.self)
        super.init(rootView: rootView)
        
        // hide default navigation back button
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @available(*, unavailable)
    @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The name that will appear in Xcode's View Hierarchy debugger
    let viewHierarchyName: String
    
    // Override description to show custom name in View Hierarchy debugger
    override public var description: String {
        viewHierarchyName
    }
    
    // Override debugDescription to show custom name in debugging contexts
    override public  var debugDescription: String {
        viewHierarchyName
    }
}
