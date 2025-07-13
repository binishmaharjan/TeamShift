import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background((configuration.isPressed || !isEnabled) ? Color.backgroundPrimary : Color.backgroundPrimary)
            .foregroundStyle((configuration.isPressed || !isEnabled) ? Color.appPrimaryPressed : Color.text)
            .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 21, style: .continuous)
                    .stroke(lineWidth: 1)
                    .fill(Color.text.opacity(0.3))
            }
    }
}

public struct SecondaryButton: View {
    public init(image: Image? = nil, title: String, isTemplate: Bool = true, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.isTemplate = isTemplate
        self.action = action
    }
    
    private let image: Image?
    private let title: String
    private let isTemplate: Bool
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if let image {
                    image
                        .resizable()
                        .renderingMode(isTemplate ? .template : .original)
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                
                Text(title)
                    .font(.customFootnote.bold())
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
