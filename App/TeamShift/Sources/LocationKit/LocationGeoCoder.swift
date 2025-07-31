import CoreLocation
import Dependencies
import DependenciesMacros
import Foundation
import SharedModels

// swiftlint:disable:next file_types_order
public class LocationGeoCoder: @unchecked Sendable {
    private var geoCoder = CLGeocoder()
    private var cache: [String: String] = [:]
    
    public func reverse(from coordinate: Coordinate) async -> String {
        let key = "\(coordinate.latitude),\(coordinate.longitude)"
        
        // Check cache first
        if let cachedAddress = cache[key] {
            return cachedAddress
        }
        
        if geoCoder.isGeocoding {
            return String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
        }
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placeMarks = try await geoCoder.reverseGeocodeLocation(location)
            
            if let placeMark = placeMarks.first {
                let formattedAddress = formatAddress(from: placeMark, coordinate: coordinate)
                
                // Cache the result
                cache[key] = formattedAddress
                return formattedAddress
            }
        } catch {
            print("Geocoding failed: \(error)")
        }
        
        let fallbackAddress = String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
        cache[key] = fallbackAddress
        return fallbackAddress
    }
    
    private func formatAddress(from placeMark: CLPlacemark, coordinate: Coordinate) -> String {
        var addressComponents: [String] = []
        
        // 1. Name/Point of Interest (e.g., "Apple Inc")
        if let name = placeMark.name {
            // Only include name if it's not just the street address
            let streetAddressParts = [placeMark.subThoroughfare, placeMark.thoroughfare]
                .compactMap { $0 }
                .joined(separator: " ")
            
            if name != streetAddressParts {
                addressComponents.append(name)
            }
        }
        
        // 2. Street Address (e.g., "1 Apple Park Way")
        var streetAddress: [String] = []
        if let subThoroughfare = placeMark.subThoroughfare {
            streetAddress.append(subThoroughfare)
        }
        if let thoroughfare = placeMark.thoroughfare {
            streetAddress.append(thoroughfare)
        }
        if !streetAddress.isEmpty {
            addressComponents.append(streetAddress.joined(separator: " "))
        }
        
        // 3. City (e.g., "Cupertino")
        if let locality = placeMark.locality {
            addressComponents.append(locality)
        }
        
        // 4. State and ZIP Code (e.g., "CA 95014")
        var stateZip: [String] = []
        if let administrativeArea = placeMark.administrativeArea {
            stateZip.append(administrativeArea)
        }
        if let postalCode = placeMark.postalCode {
            stateZip.append(postalCode)
        }
        if !stateZip.isEmpty {
            addressComponents.append(stateZip.joined(separator: " "))
        }
        
        // 5. Country (e.g., "United States")
        if let country = placeMark.country {
            addressComponents.append(country)
        }
        
        // Join all components with ", "
        let formattedAddress = addressComponents.joined(separator: ", ")
        
        // If we don't have enough components, fall back to coordinates
        return formattedAddress.isEmpty ?
        String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude) :
        formattedAddress
    }
    
    // Optional: Method to get a shorter version without country for domestic use
    public func reverseShort(from coordinate: Coordinate) async -> String {
        let fullAddress = await reverse(from: coordinate)
        
        // Remove the last component (country) if it exists
        let components = fullAddress.components(separatedBy: ", ")
        if components.count > 1 {
            return components.dropLast().joined(separator: ", ")
        }
        
        return fullAddress
    }
    
    // Optional: Method to get just the street address
    public func reverseStreetAddress(from coordinate: Coordinate) async -> String {
        let key = "\(coordinate.latitude),\(coordinate.longitude)_street"
        
        if let cachedStreet = cache[key] {
            return cachedStreet
        }
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placeMarks = try await geoCoder.reverseGeocodeLocation(location)
            
            if let placeMark = placeMarks.first {
                var streetComponents: [String] = []
                
                if let subThoroughfare = placeMark.subThoroughfare {
                    streetComponents.append(subThoroughfare)
                }
                if let thoroughfare = placeMark.thoroughfare {
                    streetComponents.append(thoroughfare)
                }
                
                let streetAddress = streetComponents.joined(separator: " ")
                cache[key] = streetAddress
                return streetAddress.isEmpty ?
                String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude) :
                streetAddress
            }
        } catch {
            print("Geocoding failed: \(error)")
        }
        
        let fallback = String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
        cache[key] = fallback
        return fallback
    }
}

// MARK: Test Class
private class TestLocationGeoCoder: LocationGeoCoder, @unchecked Sendable {
    override func reverse(from coordinate: Coordinate) async -> String {
        "Apple Inc, 1 Apple Park Way, Cupertino, CA 95014, United States"
    }
    
    override func reverseShort(from coordinate: Coordinate) async -> String {
        "Apple Park, 1 Apple Park Way, Cupertino, CA 95014"
    }
    
    override func reverseStreetAddress(from coordinate: Coordinate) async -> String {
        "1 Apple Park Way"
    }
}

// MARK: Dependency
extension DependencyValues {
    public var locationGeoCoder: LocationGeoCoder {
        get { self[LocationGeoCoder.self] }
        set { self[LocationGeoCoder.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension LocationGeoCoder: TestDependencyKey {
    public static var testValue: LocationGeoCoder {
        TestLocationGeoCoder()
    }
}

// MARK: Live
extension LocationGeoCoder: DependencyKey {
    public static var liveValue: LocationGeoCoder {
        LocationGeoCoder()
    }
}
