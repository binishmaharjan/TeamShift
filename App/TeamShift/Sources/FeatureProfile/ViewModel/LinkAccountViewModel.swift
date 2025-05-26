import ClientAuthentication
import ClientUserStore
import Dependencies
import Foundation
import Observation
import SharedModels
import SharedUIs

@Observable @MainActor
final class LinkAccountViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Properties
    var email: String = ""
    var password: String = ""
    var alertConfig: AlertDialog.Config?
    var isLoading = false
    var isSignInButtonEnabled: Bool {
        email.isEmail && password.count > 5
    }
    
    private var userSession: UserSession { .shared }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    @ObservationIgnored
    @Dependency(\.userStoreClient) var userStoreClient
    
    func signInButtonTapped() async {
        guard let currentUser = userSession.appUser, let uid = userSession.uid, userSession.isGuestUser else {
            // TODO: Error Handling
            return
        }
        
        isLoading = true
        do {
            try await authenticationClient.linkAccount(withEmail: email, password: password)
            
            let dict = SendableDictionary(currentUser.dictionaryBuilder().signInMethod(.email).dictionary)
            try await userStoreClient.updateUser(uid: uid, fields: dict)
            
            isLoading = false
            linkSuccess()
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
    
    func signInWithGoogleButtonTapped() async {
        guard let currentUser = userSession.appUser, let uid = userSession.uid, userSession.isGuestUser else {
            // TODO: Error Handling
            return
        }
        
        isLoading = true
        do {
            try await authenticationClient.linkAccountWithGmail()
            
            let dict = SendableDictionary(currentUser.dictionaryBuilder().signInMethod(.google).dictionary)
            try await userStoreClient.updateUser(uid: uid, fields: dict)
            
            isLoading = false
            linkSuccess()
        } catch {
            isLoading = false
            showErrorAlert(error)
        }
    }
}

extension LinkAccountViewModel {
    private func linkSuccess() {
        alertConfig = .success(message: l10.linkAccountAlertLinkSuccess) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
                self?.email = ""
                self?.password = ""
            }
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        alertConfig = .error(message: error.localizedDescription) { [weak self] in
            Task { @MainActor in
                self?.alertConfig = nil
            }
        }
    }
}
