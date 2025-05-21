import Foundation

public enum CollectionID: String {
    /// id to users collection
    case users
    // id to appConfig
    case appConfig = "app_config"
}

public enum DocumentID: String {
    // reference to appConfig/settings
    case settings
}
