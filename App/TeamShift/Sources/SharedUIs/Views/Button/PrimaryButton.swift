import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background((configuration.isPressed || !isEnabled) ? Color.appPrimaryPressed : Color.appPrimary)
            .foregroundStyle((configuration.isPressed || !isEnabled) ? Color.backgroundPrimary.opacity(0.5) : Color.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
    }
}

public struct PrimaryButton: View {
    public init(image: Image? = nil, title: String, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.action = action
    }
    
    private let image: Image?
    private let title: String
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if let image {
                    image
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                
                Text(title)
                    .font(.customFootnote.bold())
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
