import Foundation

extension Array where Element == String {
    /// Converts the first string to lowercase and the rest to uppercase, then joins them into a single string.
    var joinedWithCaseConversion: String {
        guard !isEmpty else {
            return ""
        }
        
        let result = enumerated().map { index, element in
            if index == 0 {
                element.lowerizeFirstLetter
            } else {
                element.capitalizeFirstLetter
            }
        }.joined()
        
        return result
    }
}
