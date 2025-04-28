import Foundation

/// Required File extensions
enum FileExtension: String {
    /// Catalog Assets
    case xcassets
    /// Color Set
    case colorset
    /// Image Set
    case imageset
    
    var fetcher: any AssetFetcher {
        switch self {
        case .xcassets:
            // TODO: This will be not called, but still don't want to leave as fatalError()
            fatalError("xcassets does not have AssetFetcher.")
        case .colorset:
            return ColorAssetFetcher()
        case .imageset:
            return ImageAssetFetcher()
        }
    }
}
