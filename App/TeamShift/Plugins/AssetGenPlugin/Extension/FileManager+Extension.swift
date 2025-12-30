import Foundation

extension FileManager {
    /// creates directory if it does not exist at path
    func createDirectoryIfNotExists(atPath path: String) throws {
        guard !fileExists(atPath: path) else { return }
        try createDirectory(atPath: path, withIntermediateDirectories: true)
    }
}

extension FileManager {
    /// returns all file name with specific asset
    func fetchAssets<Fetcher: AssetFetcher>(using fetcher: Fetcher, atPath path: String) throws -> [Fetcher.AssetType] {
        try fetcher.fetchAssets(atPath: path)
    }
}
