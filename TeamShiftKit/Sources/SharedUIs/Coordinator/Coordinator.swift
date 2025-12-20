import Foundation
import UIKit

// https://vbat.dev/coordinators-swiftui
// MARK: - Coordinator Protocol
/// A protocol that defines the basic responsibilities of a coordinator.
/// Coordinators manage the flow and navigation of view controllers.
@MainActor
public protocol Coordinator: CoordinatorFinishDelegate {
    /// The type of result this coordinator produces when it finishes.
    /// Use 'Void' if the coordinator does not produce a specific result value.
    associatedtype ResultType
    
    /// Delegate to notify when the coordinator finishes its task.
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    var topMostViewController: UIViewController { get }
    
    /// Starts the coordinator's task.
    func start()
    
    /// Finishes the coordinator's task and informs the finish delegate.
    func finish(with resultType: ResultType?)
}

// MARK: - Coordinator Default Implementation
extension Coordinator {
    /// Default implementation to notify the finish delegate that the coordinator has finished.
    public func finish(with resultType: ResultType? = nil) {
        finishDelegate?.didFinish(childCoordinator: self, with: resultType)
    }
}
