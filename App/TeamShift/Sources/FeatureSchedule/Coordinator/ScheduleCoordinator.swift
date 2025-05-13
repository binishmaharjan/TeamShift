import SharedModels
import SharedUIs
import SwiftUI

public enum ScheduleResult {
}

@MainActor
public final class ScheduleCoordinator: FlowCoordinator {
    public typealias ResultType = ScheduleResult
    public var childCoordinator: (any Coordinator)?
    
    public var finishDelegate: (any CoordinatorFinishDelegate)?
    
    public func start() {
        
    }
}
