import Foundation

// MARK: - Coordinator Protocol
/// A protocol that defines the basic responsibilities of a coordinator.
/// Coordinators manage the flow and navigation of view controllers.
@MainActor
public protocol Coordinator: CoordinatorFinishDelegate {
    /// Delegate to notify when the coordinator finishes its task.
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// Starts the coordinator's task.
    func start()
    /// Finishes the coordinator's task and informs the finish delegate.
    func finish()
}

// MARK: - Coordinator Default Implementation
extension Coordinator {
    /// Default implementation to notify the finish delegate that the coordinator has finished.
    public func finish() {
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
