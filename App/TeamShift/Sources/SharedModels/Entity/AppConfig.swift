//
//  File.swift
//  TeamShift
//
//  Created by マハルジャン	ビニシュ on 2025/05/21.
//

import Foundation

// MARK: - Nested Structs
/// Represents the 'maintenance' section.
public struct MaintenanceInfo: Codable, Equatable, Sendable {
    enum CodingKeys: String, CodingKey {
        case message = "maintenance_message"
        case mode = "maintenance_mode"
    }
    
    let message: String
    let mode: Bool
}

/// Represents the container for dynamic version details.
/// This struct holds a dictionary where keys are version strings (e.g., "1.0.0")
/// and values are the detailed info for that specific version.
public struct VersionDetails: Codable, Equatable, Sendable {
    // Custom initializer for decoding dynamic keys.
    // This is necessary because `version_details` in Firestore is a map,
    // and its sub-keys (like "1.0.0") are not fixed property names in Swift.
    public init(from decoder: Decoder) throws {
        // Get a container that allows accessing keys dynamically (any string)
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        var decodedVersions: [String: SingleVersionInfo] = [:]

        // Iterate over all keys found in the container at this level
        for key in container.allKeys {
            // Attempt to decode the value for each key as SingleVersionInfo
            let versionInfo = try container.decode(SingleVersionInfo.self, forKey: key)
            decodedVersions[key.stringValue] = versionInfo
        }
        self.versions = decodedVersions
    }
    
    // This dictionary will hold all versions found under `version_details`
    let versions: [String: SingleVersionInfo]

    // Custom encoder for encoding the dynamic keys back to Firestore.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        for (key, value) in versions {
            // Encode each version's info using its string key
            try container.encode(value, forKey: DynamicCodingKey(stringValue: key)!)
        }
    }
}

/// Represents the details for a single app version (e.g., the content of "1.0.0").
public struct SingleVersionInfo: Codable, Equatable, Sendable {
    enum CodingKeys: String, CodingKey {
        case forceUpdate = "force_update"
        case releaseDate = "release_date"
        case updateMessage = "update_message"
    }
    
    let forceUpdate: Bool
    let releaseDate: Date
    let updateMessage: String
}

/// Helper struct for decoding/encoding dynamic keys (any string).
/// Essential for `VersionDetails` to handle keys like "1.0.0", "1.0.1", etc.
public struct DynamicCodingKey: CodingKey {
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
    
    public var stringValue: String
    public var intValue: Int?
}

/// Represents the top-level document for app configuration or settings.
public struct AppConfig: Codable, Equatable, Sendable {
    // Custom CodingKeys to map Firestore's snake_case to Swift's camelCase
    enum CodingKeys: String, CodingKey {
        case maintenance
        case versionDetails = "version_details"
    }
    
    let maintenance: MaintenanceInfo
    let versionDetails: VersionDetails
}
