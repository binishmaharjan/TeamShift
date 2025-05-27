import ClientAuthentication
import ClientUserStore
import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class DeleteAccountViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    private var userSession: UserSession { .shared }
    
    var password: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var isDeleteButtonEnabled: Bool {
        (signInMethod == .email) ? (password.count > 5) : true
    }
    var signInMethod: SignInMethod {
        userSession.appUser?.signInMethod ?? .guest
    }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    @ObservationIgnored
    @Dependency(\.userStoreClient) var userStoreClient
    
    func deleteButtonTapped() async {
        isLoading = true
        do {
            switch signInMethod {
            case .email:
                try await deleteForEmail()
                
            case .google:
                try await deleteForGmail()
                
            case .apple:
                try await deleteForApple()
                
            case .guest:
                try await deleteForGuest()
            }
            
            let uid = userSession.uid ?? ""
            try await userStoreClient.deleteUser(uid: uid)
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension DeleteAccountViewModel {
    private func deleteForEmail() async throws {
        guard let currentUser = userSession.appUser, let email = currentUser.email else {
            return
        }
        
        try await authenticationClient.deleteUserWithReAuthentication(withEmail: email, password: password)
    }
    
    private func deleteForApple() async throws {
        //: TODO
    }
    
    private func deleteForGmail() async throws {
        try await authenticationClient.deleteUserWithGoogleReAuthentication()
    }
    
    private func deleteForGuest() async throws {
        try await authenticationClient.deleteUser()
    }
}

extension DeleteAccountViewModel {
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
