import Foundation
import MapKit
import SwiftUI

public struct MapView: View {
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1_000, longitudinalMeters: 1_000)
        self.position = .region(region)
    }
    
    @State private var position: MapCameraPosition
    private var coordinate: CLLocationCoordinate2D
    
    public var body: some View {
        Map(position: $position) {
            Marker(coordinate: coordinate) { Text("") }
        }
    }
}
