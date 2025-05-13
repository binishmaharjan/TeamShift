import SharedModels
import SharedUIs
import SwiftUI

public enum WorkplaceResult {
}

@MainActor
public final class WorkplaceCoordinator: FlowCoordinator {
    public typealias ResultType = WorkplaceResult
    public var childCoordinator: (any Coordinator)?
    
    public var finishDelegate: (any CoordinatorFinishDelegate)?
    
    public func start() {
        
    }
}
