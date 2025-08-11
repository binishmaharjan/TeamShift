
import Foundation
import Observation
import SharedModels

@Observable @MainActor
final class WorkplaceDetailViewModel {
    let workplace: Workplace
    
    init(workplace: Workplace) {
        self.workplace = workplace
    }
}
