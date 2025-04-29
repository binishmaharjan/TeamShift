import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background((configuration.isPressed || !isEnabled) ? Color.primaryHighlighted : Color.primary)
            .foregroundStyle((configuration.isPressed || !isEnabled) ? Color.background.opacity(0.5) : Color.background)
            .font(.customSubHeadline)
            .mask(RoundedRectangle(cornerRadius: 30))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    public static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
