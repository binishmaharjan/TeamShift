import Dependencies
import Foundation
import Observation
import SharedUIs

@Observable @MainActor
final class LicenseViewModel {
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    @ObservationIgnored
    private weak var coordinator: ProfileCoordinator?
    
    var licenses = LicensePlugin.licenses
    
    func licenseRowTapped(for license: LicensePlugin.License) {
        guard let licenseText = license.licenseText else { return }
        coordinator?.pushLicenseDescription(licenseName: license.name, licenseText: licenseText)
    }
}
