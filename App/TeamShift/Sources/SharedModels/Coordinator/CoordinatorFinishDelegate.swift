import Foundation

// MARK: - Coordinator Finish Delegate
/// A protocol to notify when a child coordinator has finished its task.
@MainActor
public protocol CoordinatorFinishDelegate: AnyObject {
    /// Called when a child coordinator has completed its flow.
    @MainActor
    func didFinish(childCoordinator: Coordinator)
}
