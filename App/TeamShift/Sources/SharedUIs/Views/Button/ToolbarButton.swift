import SwiftUI

public struct ToolbarButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.customHeadline)
            .foregroundStyle((configuration.isPressed || !isEnabled) ? Color.appPrimary.opacity(0.5) : Color.appPrimary)
    }
}

extension ButtonStyle where Self == ToolbarButtonStyle {
    public static var toolbar: ToolbarButtonStyle {
        ToolbarButtonStyle()
    }
}
