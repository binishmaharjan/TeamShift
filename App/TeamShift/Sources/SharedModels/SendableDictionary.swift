import Foundation

public struct SendableDictionary: @unchecked Sendable {
    public init(_ dictionary: [String : Any]) {
        self.dictionary = dictionary
    }
    
    public let dictionary: [String: Any]
}

extension Dictionary where Key == String, Value == Any {
    public var asSendable: SendableDictionary {
        SendableDictionary(self)
    }
}
