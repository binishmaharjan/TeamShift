import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background((configuration.isPressed || !isEnabled) ? Color.appPrimaryHighlighted : Color.appPrimary)
            .foregroundStyle((configuration.isPressed || !isEnabled) ? Color.background.opacity(0.5) : Color.background)
            .font(.customSubHeadline)
            .mask(RoundedRectangle(cornerRadius: 10))
    }
}

public struct PrimaryButton: View {
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
        .buttonStyle(.primary)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    public static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
