import Foundation

// MARK: - FlowCoordinator Protocol
/// A coordinator that manages only a single child coordinator at a time.
public protocol FlowCoordinator: Coordinator {
    /// The currently active child coordinator.
    var childCoordinator: Coordinator? { get set }
}

// MARK: - FlowCoordinator Default Implementation
extension FlowCoordinator {
    /// Sets the child coordinator and assigns the finish delegate.
    public func addChild(_ coordinator: Coordinator) {
        childCoordinator = coordinator
        coordinator.finishDelegate = self
    }
    
    /// Removes the currently active child coordinator.
    public func removeChild() {
        childCoordinator = nil
    }
    
    /// Handles the finishing of the current child coordinator by removing it.
    public func didFinish(childCoordinator: Coordinator) {
        removeChild()
    }
}
