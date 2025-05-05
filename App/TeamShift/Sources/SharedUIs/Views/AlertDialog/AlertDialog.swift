import SwiftUI

public struct AlertDialog: View {
    public struct Config {
        public init(content: String, tint: Color, foregroundColor: Color, action: @escaping (String) -> Void = { _ in }) {
            self.content = content
            self.tint = tint
            self.foregroundColor = foregroundColor
            self.action = action
        }
        
        var content: String
        var tint: Color
        var foregroundColor: Color
        var action: (String) -> Void
    }
    
    // MARK: Init
    public init(
        title: String,
        content: String? = nil,
        image: Config,
        primaryButton: Config,
        secondaryButton: Config? = nil,
        addTextField: Bool = false,
        textFieldHint: String = ""
    ) {
        self.title = title
        self.content = content
        self.image = image
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.addTextField = addTextField
        self.textFieldHint = textFieldHint
    }
    
    // MARK: Properties
    var title: String
    var content: String?
    var image: Config
    var primaryButton: Config
    var secondaryButton: Config?
    var addTextField: Bool
    var textFieldHint: String
    
    @State private var text: String = ""
    
    // MARK: Properties
    public var body: some View {
        VStack(spacing: 15) {
            Image(systemName: image.content)
                .font(.title)
                .foregroundStyle(image.foregroundColor)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
                .background {
                    Circle()
                        .stroke(.background, lineWidth: 8)
                }
            
            Text(title)
                .font(.customSubHeadline)
            
            if let content {
                Text(content)
                    .font(.customSubHeadline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 4)
            }
            
            if addTextField {
                TextField(textFieldHint, text: $text)
                    .font(.customSubHeadline)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.1))
                    }
                    .padding(.bottom, 5)
            }
            
            buttonView(primaryButton)
            
            if let secondaryButton {
                buttonView(secondaryButton)
                    .padding(.top, -5)
            }
        }
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 30)
        }
        .frame(maxWidth: 310)
        .compositingGroup()
    }
    
    @ViewBuilder
    private func buttonView(_ config: Config) -> some View {
        Button {
            config.action(addTextField ? text : "")
        } label: {
            Text(config.content)
                .font(.customFootnote.bold())
                .foregroundStyle(config.foregroundColor)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
}

extension AlertDialog {
    
}
