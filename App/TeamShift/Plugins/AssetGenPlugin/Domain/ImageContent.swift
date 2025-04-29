import Foundation

/// Structure matching the Content.json file of Image asset
struct ImageContent: Decodable {
    // Nested struct for the value part of the "images" dictionary
    struct Image: Decodable {
        let filename: String?
    }

    let images: [Image]
}
