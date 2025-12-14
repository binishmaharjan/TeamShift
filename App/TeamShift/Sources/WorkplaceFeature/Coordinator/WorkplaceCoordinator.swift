import LocationKit
import SharedModels
import SharedUIs
import SwiftUI

public enum WorkplaceResult {
}

@MainActor
public final class WorkplaceCoordinator: FlowCoordinator {
    public typealias ResultType = WorkplaceResult
    
    // MARK: Init
    public init(navigationController: NavigationController) {
        print("ℹ️ \(Self.self): Start WorkplaceCoordinator")
        startViewController = navigationController
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit WorkplaceCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public  let startViewController: NavigationController
    private var navigationControllers = [NavigationController]()
    private var routePresentationDelegates: [PresentationDelegate] = []
    public var topMostViewController: UIViewController {
        navigationControllers.last?.topMostViewController ?? startViewController
    }
    private var topNavigationController: NavigationController {
        navigationControllers.last ?? startViewController
    }
    private var rootNavigationController: NavigationController {
        navigationControllers.first ?? startViewController
    }
    
    public func start() {
        navigationControllers.append(startViewController)
        
        let viewModel = WorkplaceViewModel(coordinator: self)
        let viewController = WorkplaceViewController(viewModel: viewModel)
        viewController.title = l10.workplaceNavTitle
        startViewController.setViewControllers([viewController], animated: false)
    }
}

// MARK: Navigation
extension WorkplaceCoordinator {
    func workplaceRequestNavigation(for route: WorkplaceViewModel.Route) {
        switch route {
        case .showAddWorkplace:
            pushCreateWorkplaceView()
        }
    }
    
    private func pushCreateWorkplaceView() {
        let viewModel = CreateWorkplaceViewModel(coordinator: self)
        let viewController = CreateWorkplaceViewController(viewModel: viewModel)
        viewController.title = l10.createWorkplaceNavTitle
        topNavigationController.pushViewController(viewController, animated: true)
    }
    
    func presentLocationPicker(_ onLocationSelected: @escaping (Coordinate?) -> Void) {
        let viewController = LocationPickerViewController(onLocationSelected: onLocationSelected) { [weak self] in
            // remove presentation delegate when close button is tapped
            self?.routePresentationDelegates.removeLast()
        }
        
        // for swipe down
        let presentationDelegate = PresentationDelegate { [weak self] in
            self?.routePresentationDelegates.removeLast()
        }
        viewController.presentationController?.delegate = presentationDelegate
        routePresentationDelegates.append(presentationDelegate)
        
        topNavigationController.present(viewController, animated: true)
    }
    
    func popLast() {
        topNavigationController.popViewController(animated: true)
    }
}

// MARK: Create Workplace Navigation
extension WorkplaceCoordinator {
    func createWorkplaceRequestNavigation(for route: CreateWorkplaceViewModel.Route) {
        switch route {
        case .showWorkplaceDetail(let workplace):
            showSuccessAlert(message: l10.createWorkplaceAlertSuccess) { [weak self] in
                self?.pushWorkplaceDetailView(workplace: workplace)
            }
        }
    }
    
    private func pushWorkplaceDetailView(workplace: Workplace) {
        let viewModel = WorkplaceDetailViewModel(workplace: workplace)
        let viewController = WorkplaceDetailViewController(viewModel: viewModel)
        viewController.title = workplace.name
        
        var viewControllers = topNavigationController.viewControllers
        viewControllers.removeLast()
        viewControllers.append(viewController)
        topNavigationController.setViewControllers(viewControllers, animated: true)
    }
}

/*
 LocationPicker — App/TeamShift/Sources/LocationKit/LocationPicker.swift
 */
