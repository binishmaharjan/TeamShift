import Foundation
import Observation
import SharedModels

@Observable @MainActor
final class WorkplaceDetailViewModel {
    init(workplace: Workplace) {
        self.workplace = workplace
    }
    
    let workplace: Workplace
}
