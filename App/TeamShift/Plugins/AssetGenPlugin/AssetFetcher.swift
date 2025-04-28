import Foundation

/// Strategy Pattern
/// Protocol
protocol AssetFetcher {
    associatedtype AssetType: Asset
    func fetchAssets(atPath path: String) throws -> [AssetType]
}

/// Implementation for Color Asset
struct ColorAssetFetcher: AssetFetcher {
    /// returns all file name with extension color set
    func fetchAssets(atPath path: String) throws -> [ColorAsset] {
        try FileManager.default.contentsOfDirectory(atPath: path)
            .filter { $0.hasSuffix(FileExtension.colorset.rawValue) }
            .compactMap { $0.components(separatedBy: ".").first }
            .map { ColorAsset(originalName: $0, camelCaseName: $0.toCamelCase) }
    }
}

/// Implementation for Color Asset
struct ImageAssetFetcher: AssetFetcher {
    /// returns all file name with extension image set
    func fetchAssets(atPath path: String) throws -> [ImageAsset] {
        let imagesName: [String?] = try FileManager.default.contentsOfDirectory(atPath: path)
            .filter { $0.hasSuffix(FileExtension.imageset.rawValue) }
            .map { dirent in
                let contentsJsonURL = URL(fileURLWithPath: "\(path)/\(dirent)/Contents.json")
                let jsonData = try Data(contentsOf: contentsJsonURL)
                let assetCatalogContents = try JSONDecoder().decode(ImageContent.self, from: jsonData)
                let hasImage = assetCatalogContents.images.filter { $0.filename != nil }.isEmpty == false
                
                if hasImage {
                    let baseName = contentsJsonURL.deletingLastPathComponent().deletingPathExtension().lastPathComponent
                    return baseName
                }
                
                return nil
            }
            
        return imagesName
            .compactMap { $0 }
            .map { ImageAsset(originalName: $0, camelCaseName: $0.toCamelCase) }
    }
}
