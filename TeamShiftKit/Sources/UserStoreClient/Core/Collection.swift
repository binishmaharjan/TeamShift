import Foundation

public enum DocumentID: String {
    // reference to appConfig/settings
    case settings
}

public enum CollectionID: String {
    /// id to users collection
    case users
    // id to appConfig
    case appConfig = "app_config"
    // id to workplace
    case workplaces
}
