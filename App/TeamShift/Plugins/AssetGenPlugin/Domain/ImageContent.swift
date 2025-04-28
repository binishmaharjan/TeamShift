import Foundation

/// Representation for Content.json file of Image asset
struct ImageContent: Decodable {
    /// Representation of Image asset
    struct Image: Decodable {
        let filename: String?
    }

    let images: [Image]
}
