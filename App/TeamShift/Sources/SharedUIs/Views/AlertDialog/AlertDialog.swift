import SwiftUI

public struct AlertDialog: View {
    public enum Kind: Sendable {
        case info(title: String, message: String?)
        case confirm(title: String, message: String?)
        case error(message: String?)
        case success(message: String?)
        
        var tint: Color {
            switch self {
            case .info, .confirm:
                return .appPrimary
                
            case .error:
                return .activityIndicator
                
            case .success:
                return .appError
            }
        }
        
        var foregroundColor: Color {
            .background
        }
        
        var title: String {
            switch self {
            case .info(let title, _), .confirm(let title, _):
                return title
                
            case .error:
                return "Error"
                
            case .success:
                return "Success"
            }
        }
        
        var message: String? {
            switch self {
            case .info(_, let message), .confirm(_, let message), .error(let message), .success(let message):
                return message
            }
        }
    }
    
    public enum ButtonType: Sendable {
        case primary(title: String)
        case secondary(title: String)
        
        var title: String {
            switch self {
            case .primary(let title), .secondary(let title):
                return title
            }
        }
        
        var foregroundColor: Color {
            .background
        }
        
        var tint: Color {
            switch self {
            case .primary:
                return .appPrimary
                
            case .secondary:
                return .appError
            }
        }
    }
    
    public struct ButtonConfig: Identifiable, Sendable {
        public init(type: ButtonType, action: (@Sendable (String?) -> Void)? = nil) {
            self.type = type
            self.action = action
        }
        
        public let id = UUID()
        var type: ButtonType
        var action: (@Sendable (String?) -> Void)?
    }
    
    public struct Config: Sendable {
        public init(kind: Kind, image: String, buttons: [ButtonConfig], addTextField: Bool = false, textFieldHint: String = "") {
            self.kind = kind
            self.image = image
            self.buttons = buttons
            self.addTextField = addTextField
            self.textFieldHint = textFieldHint
        }
        
        var kind: Kind
        var image: String
        var buttons: [ButtonConfig]
        var addTextField: Bool
        var textFieldHint: String
    }
    
    var config: Config
    
    @State private var text: String = ""
    
    // MARK: Properties
    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: config.image)
                .font(.title)
                .foregroundStyle(config.kind.foregroundColor)
                .frame(width: 65, height: 65)
                .background(config.kind.tint.gradient, in: .circle)
                .background {
                    Circle()
                        .stroke(.background, lineWidth: 8)
                }
            
            Text(config.kind.title)
                .font(.customSubHeadline)
            
            if let message = config.kind.message {
                Text(message)
                    .font(.customCaption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.subText)
                    .padding(.bottom, 4)
            }
            
            if config.addTextField {
                TextField(config.textFieldHint, text: $text)
                    .font(.customSubHeadline)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.subText.opacity(0.1))
                    }
                    .padding(.bottom, 5)
            }
            
            ForEach(config.buttons) { buttonConfig in
                buttonView(buttonConfig)
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
    private func buttonView(_ buttonConfig: ButtonConfig) -> some View {
        Button {
            buttonConfig.action?(config.addTextField ? text : nil)
        } label: {
            Text(buttonConfig.type.title)
                .font(.customFootnote.bold())
                .foregroundStyle(buttonConfig.type.foregroundColor)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(buttonConfig.type.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
}

extension AlertDialog.Config {
    public static func info(title: String, message: String) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .info(title: title, message: message),
            image: "folder.fill.badge.plus",
            buttons: [
                .init(type: .primary(title: "OK")) { _ in }
            ]
        )
    }
    
    public static func confirm(
        buttonTitle: String,
        title: String,
        message: String,
        primaryAction: (@Sendable (String?) -> Void)?,
        secondaryAction: (@Sendable (String?) -> Void)?
    ) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .info(title: title, message: message),
            image: "folder.fill.badge.plus",
            buttons: [
                .init(type: .primary(title: buttonTitle), action: primaryAction) ,
                .init(type: .secondary(title: "Cancel"), action: secondaryAction)
            ]
        )
    }
    
    public static func error(message: String) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .error(message: message),
            image: "folder.fill.badge.plus",
            buttons: [
                .init(type: .primary(title: "OK")) { _ in },
            ]
        )
    }
    
    public static func success(message: String) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .success(message: message),
            image: "folder.fill.badge.plus",
            buttons: [
                .init(type: .primary(title: "OK")) { _ in },
            ]
        )
    }
}
