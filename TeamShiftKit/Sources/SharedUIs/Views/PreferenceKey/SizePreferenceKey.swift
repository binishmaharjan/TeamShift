import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
    /// Note: nonisolated(unsafe) -> No need for concurrent feature since it wont cause any data races.
    public nonisolated(unsafe) static var defaultValue: CGFloat = 60
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
