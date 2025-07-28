import CoreLocation
import Foundation
import MapKit
import SwiftUI

@Observable
class LocationManager: NSObject {
    // MARK: Init
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // MARK: Properties
    var isUpdating: Bool = false
    var isPermissionDenied: Bool = false
    // MARK: Properties-Map
    var currentRegion: MKCoordinateRegion?
    var position: MapCameraPosition = .automatic
    var userCoordinates: CLLocationCoordinate2D?
    var selectedCoordinate: CLLocationCoordinate2D?
    // MARK: Properties-Search
    var searchText = ""
    var searchResult: [MKPlacemark] = []
    var selectedResult: MKPlacemark?
    var showSearchResults = false
    var isSearching = false
    
    private var manager = CLLocationManager()
}

// MARK: CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        guard status != .notDetermined else { return }
        
        isPermissionDenied = status == .denied
        if status != .denied {
            // start fetching location
            isUpdating = true
            manager.startUpdatingLocation()
        } else {
            isUpdating = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first?.coordinate else { return }
        
        // updating user coordinates and map camera position
        userCoordinates = coordinates
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1_000, longitudinalMeters: 1_000)
        position = .region(region)
        
        // stop updates
        isUpdating = false
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    }
}

// MARK: Helper Methods
extension LocationManager {
    func requestUserLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    @MainActor
    func searchForPlaces() {
        // current region based search
        guard let currentRegion else { return }
        
        Task { @MainActor in
            isSearching = true
            
            let request = MKLocalSearch.Request()
            request.region = currentRegion
            request.naturalLanguageQuery = searchText
            guard let response = try? await MKLocalSearch(request: request).start() else {
                isSearching = false
                return
            }
            
            searchResult = response.mapItems.compactMap(\.placemark)
            isSearching = false
        }
    }
    
    func clearSearchResult() {
        searchText = ""
        searchResult = []
    }
    
    func updateMapPosition(_ placemark: MKPlacemark) {
        let coordinates = placemark.coordinate
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1_000, longitudinalMeters: 1_000)
        position = .region(region)
        selectedResult = placemark
        showSearchResults = false
        selectedCoordinate = placemark.coordinate
    }
}
