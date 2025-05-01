import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background((configuration.isPressed || !isEnabled) ? Color.appSecondaryHighlighted : Color.appSecondary)
            .foregroundStyle((configuration.isPressed || !isEnabled) ? Color.appPrimaryHighlighted : Color.appPrimary)
            .font(.customSubHeadline)
            .mask(RoundedRectangle(cornerRadius: 10))
    }
}

public struct SecondaryButton: View {
    public init(image: Image, title: String, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.action = action
    }
    
    private let image: Image
    private let title: String
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            HStack {
                image
                    .renderingMode(.template)
                
                Text(title)
            }
        }
        .buttonStyle(.secondary)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    public static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}
