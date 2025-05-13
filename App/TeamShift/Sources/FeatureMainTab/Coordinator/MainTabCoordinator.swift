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
        print("\(Self.self): Start MainTabCoordinator")
    }
    
    deinit {
        print("\(Self.self): Deinit MainTabCoordinator")
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
        let scheduleTabView = UINavigationController()
        let scheduleCoordinator = ScheduleCoordinator(navigationController: scheduleTabView)
        
        let workplaceTabView = UINavigationController()
        let workplaceCoordinator = WorkplaceCoordinator(navigationController: workplaceTabView)
        
        let profileTabView = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileTabView)
        
        addChild(scheduleCoordinator)
        addChild(workplaceCoordinator)
        addChild(profileCoordinator)
        
        scheduleCoordinator.start()
        workplaceCoordinator.start()
        profileCoordinator.start()
        
        tabViewController.viewControllers = [
            scheduleTabView,
            workplaceTabView,
            profileTabView
        ]
        scheduleTabView.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(systemName: "house"), tag: 0)
        workplaceTabView.tabBarItem = UITabBarItem(title: "Workplace", image: UIImage(systemName: "house"), tag: 1)
        profileTabView.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "house"), tag: 2)
        
        self.scheduleCoordinator = scheduleCoordinator
        self.workplaceCoordinator = workplaceCoordinator
        self.profileCoordinator = profileCoordinator
    }
}
