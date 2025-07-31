import Dependencies
import Foundation

public struct Coordinate: Codable, Sendable, Equatable {
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public let latitude: Double
    public let longitude: Double
}

@DictionaryBuilder
public struct Workplace: Equatable, Identifiable, Codable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownerId = "owner_id"
        case branchName = "branch_name"
        case locationName = "location_name"
        case locationCoords = "location_coords"
        case phoneNumber = "phone_number"
        case description
    }
    
    public init(
        name: String,
        ownerId: String,
        branchName: String? = nil,
        locationName: String? = nil,
        locationCoords: Coordinate? = nil,
        phoneNumber: String? = nil,
        description: String? = nil
    ) {
        @Dependency(\.randomIDHelper) var randomIDHelper
        self.id = randomIDHelper.generate()
        self.name = name
        self.ownerId = ownerId
        self.branchName = branchName
        self.locationName = locationName
        self.locationCoords = locationCoords
        self.phoneNumber = phoneNumber
        self.description = description
    }
    
    public let id: String
    public var name: String
    public let ownerId: String
    public var branchName: String?
    public var locationName: String?
    public var locationCoords: Coordinate?
    public var phoneNumber: String?
    public var description: String?
}
