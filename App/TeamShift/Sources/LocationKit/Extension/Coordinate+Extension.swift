import CoreLocation
import SharedModels

extension Coordinate {
    init?(from clLocationCoordinate2D: CLLocationCoordinate2D?) {
        guard let clLocationCoordinate2D else { return nil }
        self.init(latitude: clLocationCoordinate2D.latitude, longitude: clLocationCoordinate2D.longitude)
    }
}
