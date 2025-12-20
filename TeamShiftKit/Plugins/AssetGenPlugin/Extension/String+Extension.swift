import Foundation

extension String {
    /// Converts the words to camel case
    var toCamelCase: String {
        replaceSpecialCharacter(with: "_")
            .splitWord(by: "_")
            .joinedWithCaseConversion
    }
    
    /// Splits a word with specified character
    func splitWord(by char: String) -> [String] {
        components(separatedBy: char)
    }
    
    /// Replaces all non-alphanumeric characters in the string with a specified character.
    func replaceSpecialCharacter(with char: String) -> String {
        let pattern = "[^a-zA-Z0-9]"
        return replacingOccurrences(of: pattern, with: char, options: .regularExpression)
    }
    
    /// Upper-cases the first letter of a word
    var capitalizeFirstLetter: String {
        guard let firsLetter = first else {
            return ""
        }
        
        return String(firsLetter).uppercased() + dropFirst()
    }
    
    var lowerizeFirstLetter: String {
        guard let firstLetter = first else {
            return ""
        }
        
        return String(firstLetter).lowercased() + dropFirst()
    }
}
