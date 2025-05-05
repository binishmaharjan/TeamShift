import ClientAuthentication
import ClientUserStore
import Dependencies
import Foundation
import Observation

@Observable @MainActor
final class CreateAccountViewModel {
    // MARK: Properties
    var didRequestFinish: ((AuthenticationResult) -> Void)?
    var email = ""
    var password = ""
    var isLoading = false
    
    var isCreateButtonEnabled: Bool {
        email.isEmail && password.count > 5
    }
    
    @ObservationIgnored
    @Dependency(\.authenticationClient) var authenticationClient
    @ObservationIgnored
    @Dependency(\.userStoreClient) var userStoreClient
    
    // MARK: Methods
    func createButtonTapped() async {
        isLoading = true
        do {
            let user = try await authenticationClient.createUser(withEmail: email, password: password)
            try await userStoreClient.saveUser(user: user)
            isLoading = false
            didRequestFinish?(.showMainTab)
        } catch {
            isLoading = false
            print(error)
        }
    }
}
