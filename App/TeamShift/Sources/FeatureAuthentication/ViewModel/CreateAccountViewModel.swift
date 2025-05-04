import ClientAuthentication
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
    
    // MARK: Methods
    func createButtonTapped() async {
        isLoading = true
        do {
            let uid = try await authenticationClient.createUser(withEmail: email, password: password)
            isLoading = false
            print(uid)
        } catch {
            isLoading = false
            print(error)
        }
    }
}
