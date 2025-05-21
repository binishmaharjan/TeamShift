import FeatureProfile
import FeatureSchedule
import FeatureWorkplace
import SharedModels
import SharedUIs
import SwiftUI

public enum MainTabResult {
    case showAuthentication
}

@MainActor
public final class MainTabCoordinator: CompositionCoordinator {
    public typealias ResultType = MainTabResult
    
    // MARK: Init
    public init() {
        print("ℹ️ \(Self.self): Start MainTabCoordinator")
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit MainTabCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinators: [any Coordinator] = []
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public var scheduleCoordinator: ScheduleCoordinator?
    public var workplaceCoordinator: WorkplaceCoordinator?
    public var profileCoordinator: ProfileCoordinator?
    
    public var tabViewController = UITabBarController()
    
    // MARK: Methods
    public func start() {
        setupTabBar()
        
        let scheduleTabView = setupScheduleView()
        let workplaceTabView = setupWorkplaceView()
        let profileTabView = setupProfileView()
        
        tabViewController.viewControllers = [
            scheduleTabView,
            workplaceTabView,
            profileTabView
        ]
        tabViewController.selectedIndex = 2
    }
    
    public func didFinish(childCoordinator: any Coordinator, with result: Any?) {
        if childCoordinator is ProfileCoordinator, let profileResult = result as? ProfileResult {
            switch profileResult {
            case .showOnboarding:
                finish(with: .showAuthentication)
            }
        }
        
        // Clean up
        removeChild(childCoordinator)
    }
}

extension MainTabCoordinator {
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Configure colors
        let selectedColor = UIColor(named: "app_primary", in: Bundle.sharedUIs, compatibleWith: nil)
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedColor as Any]
        
        let unselectedColor = UIColor(named: "sub_text", in: Bundle.sharedUIs, compatibleWith: nil)
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: unselectedColor as Any]
        
        tabViewController.tabBar.standardAppearance = appearance
        tabViewController.tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupScheduleView() -> UINavigationController {
        let scheduleTabView = UINavigationController()
        let scheduleCoordinator = ScheduleCoordinator(navigationController: scheduleTabView)
        
        addChild(scheduleCoordinator)
        scheduleCoordinator.start()
        
        let image = UIImage(named: "icn_calendar", in: Bundle.sharedUIs, with: nil)?.withRenderingMode(.alwaysTemplate)
        scheduleTabView.tabBarItem = UITabBarItem(title: "Schedule", image: image, tag: 0)
        self.scheduleCoordinator = scheduleCoordinator
        return scheduleTabView
    }
    
    private func setupWorkplaceView() -> UINavigationController {
        let workplaceTabView = UINavigationController()
        let workplaceCoordinator = WorkplaceCoordinator(navigationController: workplaceTabView)
        
        addChild(workplaceCoordinator)
        workplaceCoordinator.start()
        
        let image = UIImage(named: "icn_store", in: Bundle.sharedUIs, with: nil)?.withRenderingMode(.alwaysTemplate)
        workplaceTabView.tabBarItem = UITabBarItem(title: "Workplace", image: image, tag: 1)
        self.workplaceCoordinator = workplaceCoordinator
        return workplaceTabView
    }
    
    private func setupProfileView() -> UINavigationController {
        let profileTabView = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileTabView)
        
        addChild(profileCoordinator)
        profileCoordinator.start()
        
        let image = UIImage(named: "icn_badge", in: Bundle.sharedUIs, with: nil)?.withRenderingMode(.alwaysTemplate)
        profileTabView.tabBarItem = UITabBarItem(title: "Profile", image: image, tag: 2)
        self.profileCoordinator = profileCoordinator
        return profileTabView
    }
}
