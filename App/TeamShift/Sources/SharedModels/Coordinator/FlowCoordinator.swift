import Foundation

// MARK: - FlowCoordinator Protocol
/// A coordinator that manages only a single child coordinator at a time.
public protocol FlowCoordinator: Coordinator {
    /// The currently active child coordinator.
    var childCoordinator: (any Coordinator)? { get set }
}

// MARK: - FlowCoordinator Default Implementation
extension FlowCoordinator {
    /// Sets the child coordinator and assigns the finish delegate.
    public func addChild(_ coordinator: any Coordinator) {
        childCoordinator = coordinator
        print("\(Self.self): Added child \(type(of: coordinator))...")
        coordinator.finishDelegate = self
    }
    
    /// Removes the currently active child coordinator.
    public func removeChild() {
        childCoordinator = nil
        print("\(Self.self): Removed child \(type(of: childCoordinator))...")
    }
    
    /// Handles the finishing of the current child coordinator by removing it.
    public func didFinish(childCoordinator: any Coordinator, with result: Any?) {
        print("\(Self.self): Default didFinish called for \(type(of: childCoordinator))...")
        removeChild()
    }
}
