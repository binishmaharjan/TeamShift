import Foundation
import SharedModels
import SharedUIs
import SwiftUI

public enum AuthenticationResult { }

@MainActor
public final class AuthenticationCoordinator: FlowCoordinator {
    public typealias ResultType = AuthenticationResult
    
    // MARK: Init
    public init() {
        print("\(Self.self): Start AuthenticationCoordinator")
    }
    
    deinit {
        print("\(Self.self): Deinit AuthenticationCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public private(set) var startViewController = UIViewController()
    
    // MARK: Methods
    public func start() {
        let viewModel = OnboardingViewModel()
        let view = OnboardingView(coordinator: self, viewModel: viewModel)
        let viewController = NamedUIHostingController(rootView: view)
        startViewController = viewController
    }
}
