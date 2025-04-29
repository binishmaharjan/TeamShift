import Foundation

// MARK: - CompositionCoordinator Protocol
/// A coordinator that can manage multiple child coordinators simultaneously.
public protocol CompositionCoordinator: Coordinator {
    /// A list of currently active child coordinators.
    var childCoordinators: [any Coordinator] { get set }
}

// MARK: - CompositionCoordinator Default Implementation
extension CompositionCoordinator {
    /// Adds a child coordinator to the list and sets its finish delegate.
    public func addChild(_ coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
        print("\(Self.self): Added child \(type(of: coordinator))...")
        coordinator.finishDelegate = self
    }
    
    /// Removes a specific child coordinator from the list.
    public func removeChild(_ coordinator: any Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            let removedCoordinator = childCoordinators.remove(at: index)
            print("\(Self.self): Removed child \(type(of: removedCoordinator))...")
        } else {
            print("\(Self.self): Warning - Attempted to remove a child coordinator (\(type(of: coordinator)))...")
        }
    }
    
    /// Handles the finishing of a child coordinator by removing it from the list.
    public func didFinish(childCoordinator: any Coordinator, with result: Any?) {
        print("\(Self.self): Default didFinish called for \(type(of: childCoordinator))...")
        removeChild(childCoordinator)
    }
}
