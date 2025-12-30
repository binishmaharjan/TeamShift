import ApiClient
import Dependencies
import Foundation
import LocationKit
import Observation
import SharedModels

@Observable @MainActor
final class WorkplaceViewModel {
    // MARK: Enum
    enum Route {
        case showAddWorkplace
        case showWorkplaceDetail(Workplace)
    }
    
    enum Action {
        case onAppear
        case onPullToRefresh
    }
    
    // MARK: Init
    init() {}
    init(coordinator: WorkplaceCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    @ObservationIgnored
    weak var coordinator: WorkplaceCoordinator?
    @ObservationIgnored
    @Dependency(\.apiClient) private var apiClient
    @ObservationIgnored
    @Dependency(\.userSession) private var userSession
    
    var isLoading = false
    var workplaces: [Workplace]?
    
    func addWorkplaceButtonTapped() {
        coordinator?.workplaceRequestNavigation(for: .showAddWorkplace)
        Task {
            let workPlaces = try? await apiClient.getWorkplace(user: userSession.currentUser!)
            workPlaces?.forEach { workplace in
                print(workplace)
            }
        }
    }
    
    func workplaceRowTapped(_ workplace: Workplace) {
        coordinator?.workplaceRequestNavigation(for: .showWorkplaceDetail(workplace))
    }
    
    func send(action: Action) async {
        switch action {
        case .onAppear:
            await fetchWorkplaceList()
            
        case .onPullToRefresh:
            await fetchWorkplaceList(showIndicator: false)
        }
    }
}

// Private
extension WorkplaceViewModel {
    private func fetchWorkplaceList(showIndicator: Bool = true) async {
        guard let currentUser = userSession.currentUser else {
            handleError(AppError.internalError(.userNotFound))
            return
        }
        
        isLoading = true
        
        do {
            isLoading = false
            workplaces = try await apiClient.getWorkplace(user: currentUser)
        } catch {
            isLoading = false
            handleError(error)
        }
    }
}

// MARK: Alert
extension WorkplaceViewModel {
    private func handleError(_ error: Error) {
        coordinator?.handleError(error)
    }
}
