import Foundation

// Structure matching the Localizable.xcstrings JSON format
struct XCStringsFile: Decodable {
    let sourceLanguage: String?
    let version: String?
    /// The dictionary of localization keys
    let strings: [String: StringEntry]

    // Nested struct for the value part of the "strings" dictionary
    struct StringEntry: Decodable {
        let comment: String?
        let extractionState: String?
        let localizations: [String: Localization]?

        struct Localization: Decodable {
             struct StringUnit: Decodable {
                 let state: String
                 let value: String
             }
             let stringUnit: StringUnit?
        }
    }
}

