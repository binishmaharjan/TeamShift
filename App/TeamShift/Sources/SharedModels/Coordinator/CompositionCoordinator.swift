import Foundation

// MARK: - CompositionCoordinator Protocol
/// A coordinator that can manage multiple child coordinators simultaneously.
public protocol CompositionCoordinator: Coordinator {
    /// A list of currently active child coordinators.
    var childCoordinators: [Coordinator] { get set }
}

// MARK: - CompositionCoordinator Default Implementation
extension CompositionCoordinator {
    /// Adds a child coordinator to the list and sets its finish delegate.
    public func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
    }
    
    /// Removes a specific child coordinator from the list.
    public func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    /// Handles the finishing of a child coordinator by removing it from the list.
    public func didFinish(childCoordinator: Coordinator) {
        removeChild(childCoordinator)
    }
}
