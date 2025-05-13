import SharedModels
import SharedUIs
import SwiftUI

public enum ProfileResult {
}

@MainActor
public final class ProfileCoordinator: FlowCoordinator {
    public typealias ResultType = ProfileResult
    public var childCoordinator: (any Coordinator)?
    
    public var finishDelegate: (any CoordinatorFinishDelegate)?
    
    public func start() {
        
    }
}
