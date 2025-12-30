import Foundation

extension Optional where Wrapped == String {
    public var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}
