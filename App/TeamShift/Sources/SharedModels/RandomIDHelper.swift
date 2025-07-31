import Dependencies
import DependenciesMacros
import Foundation

// swiftlint:disable:next file_types_order
public class RandomIDHelper : @unchecked Sendable {
    /// Generates a 16-character alphanumeric ID similar to Firebase
    /// - Returns: Random 16-character string
    public func generate(length: Int = 16) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        return String((0 ..< length).map { _ in characters.randomElement()! })
    }
}

// MARK: Test Class
private class TestRandomIDHelper: RandomIDHelper, @unchecked Sendable {
    override public  func generate(length: Int = 16) -> String {
        "ABCDEF1234567890"
    }
}

// MARK: Dependency
extension DependencyValues {
    public var randomIDHelper: RandomIDHelper {
        get { self[RandomIDHelper.self] }
        set { self[RandomIDHelper.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension RandomIDHelper: TestDependencyKey {
    public static var testValue: RandomIDHelper {
        TestRandomIDHelper()
    }
}

// MARK: Live
extension RandomIDHelper: DependencyKey {
    public static var liveValue: RandomIDHelper {
        RandomIDHelper()
    }
}
