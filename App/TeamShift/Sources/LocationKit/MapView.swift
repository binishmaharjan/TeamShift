import Foundation
import MapKit
import SwiftUI

public struct MapView: View {
    public init(coordinate: CLLocationCoordinate2D, location: String) {
        self.coordinate = coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1_000, longitudinalMeters: 1_000)
        self.position = .region(region)
        self.location = location
    }
    
    @State private var position: MapCameraPosition
    private let coordinate: CLLocationCoordinate2D
    private let location: String
    
    public var body: some View {
        Map(position: $position) {
            Marker(coordinate: coordinate) { Text(location) }
        }
    }
}
