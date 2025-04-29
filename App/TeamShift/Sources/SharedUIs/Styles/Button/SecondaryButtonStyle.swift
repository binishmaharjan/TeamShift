import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background((configuration.isPressed || !isEnabled) ? Color.secondaryHighlighted : Color.secondary)
            .foregroundStyle((configuration.isPressed || !isEnabled) ? Color.primaryHighlighted : Color.primary)
            .font(.system(size: 14, weight: .semibold))
            .mask(RoundedRectangle(cornerRadius: 30))
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    public static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}
