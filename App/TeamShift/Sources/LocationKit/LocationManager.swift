import CoreLocation
import Foundation
import MapKit
import SwiftUI

@Observable
class LocationManager: NSObject {
    enum Result {
        case placeMark(MKPlacemark)
        case coordinate(CLLocationCoordinate2D)
    }
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
    // MARK: Properties-Search
    var searchText = ""
    var searchResult: [MKPlacemark] = []
    var showSearchResults = false
    var isSearching = false
    // MARK: Selection
    var selectedResult: Result?
    var selectedCoordinate: CLLocationCoordinate2D? {
        guard let selectedResult else { return nil }
        switch selectedResult {
        case .placeMark(let mKPlaceMark):
            return mKPlaceMark.coordinate
            
        case .coordinate(let cLLocationCoordinate2D):
            return cLLocationCoordinate2D
        }
    }
    
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
    
    func updateMapPosition(_ placeMark: MKPlacemark) {
        let coordinates = placeMark.coordinate
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1_000, longitudinalMeters: 1_000)
        position = .region(region)
        selectedResult = .placeMark(placeMark)
        showSearchResults = false
    }
    
    func mapLocationSelected(on coordinate: CLLocationCoordinate2D) {
        selectedResult = .coordinate(coordinate)
    }
    
    func isPlaceMarkSelected(_ placeMark: MKPlacemark) -> Bool {
        guard let selectedResult = selectedResult else { return false }
        switch selectedResult {
        case .placeMark(let mKPlaceMark):
            return placeMark == mKPlaceMark
            
        case .coordinate(let cLLocationCoordinate2D):
            return placeMark.coordinate.latitude == cLLocationCoordinate2D.latitude && placeMark.coordinate.longitude == cLLocationCoordinate2D.longitude
        }
    }
    
    @MainActor
    func getDetailedLocationName(from coordinate: CLLocationCoordinate2D) async -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placeMark = try await geoCoder.reverseGeocodeLocation(location)
            
            if let placeMark = placeMark.first {
                var components: [String] = []
                
                // Add name (specific place)
                if let name = placeMark.name {
                    components.append(name)
                }
                
                // Add thoroughfare (street)
                if let thoroughfare = placeMark.thoroughfare {
                    if !components.contains(thoroughfare) {
                        components.append(thoroughfare)
                    }
                }
                
                // Add locality (city)
                if let locality = placeMark.locality {
                    components.append(locality)
                }
                
                if !components.isEmpty {
                    return components.joined(separator: ", ")
                }
            }
        } catch {
            print("Reverse geocoding failed: \(error.localizedDescription)")
        }
        
        // Format coordinates nicely
        return String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
}
