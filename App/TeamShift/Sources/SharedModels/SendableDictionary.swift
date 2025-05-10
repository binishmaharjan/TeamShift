import Foundation

public struct SendableDictionary: @unchecked Sendable {
    public init(_ dictionary: [String : Any]) {
        self.dictionary = dictionary
    }
    
    public let dictionary: [String: Any]
}
