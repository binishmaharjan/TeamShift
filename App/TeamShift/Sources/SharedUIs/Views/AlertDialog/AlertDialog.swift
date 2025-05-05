import SwiftUI

public struct AlertDialog: View {
    public enum `Type` {
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
    
    public enum ButtonType {
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
    
    public struct ButtonConfig: Identifiable {
        public init(type: ButtonType, action: ((String?) -> Void)? = nil) {
            self.type = type
            self.action = action
        }
        
        public let id: UUID = UUID()
        var type: ButtonType
        var action: ((String?) -> Void)?
    }
    
    public struct Config {
        public init(type: Type, image: String, buttons: [ButtonConfig], addTextField: Bool = false, textFieldHint: String = "") {
            self.type = type
            self.image = image
            self.buttons = buttons
            self.addTextField = addTextField
            self.textFieldHint = textFieldHint
        }
        
        var type: Type
        var image: String
        var buttons: [ButtonConfig]
        var addTextField: Bool
        var textFieldHint: String
    }
    
    public struct ContentConfig {
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
//    public init(
//        title: String,
//        content: String? = nil,
//        image: ContentConfig,
//        primaryButton: ContentConfig,
//        secondaryButton: ContentConfig? = nil,
//        addTextField: Bool = false,
//        textFieldHint: String = ""
//    ) {
//        self.title = title
//        self.content = content
//        self.image = image
//        self.primaryButton = primaryButton
//        self.secondaryButton = secondaryButton
//        self.addTextField = addTextField
//        self.textFieldHint = textFieldHint
//    }
//    
//    // MARK: Properties
//    var title: String
//    var content: String?
//    var image: ContentConfig
//    var primaryButton: ContentConfig
//    var secondaryButton: ContentConfig?
//    var addTextField: Bool
//    var textFieldHint: String
    
    var config: Config
    
    @State private var text: String = ""
    
    // MARK: Properties
    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: config.image)
                .font(.title)
                .foregroundStyle(config.type.foregroundColor)
                .frame(width: 65, height: 65)
                .background(config.type.tint.gradient, in: .circle)
                .background {
                    Circle()
                        .stroke(.background, lineWidth: 8)
                }
            
            Text(config.type.title)
                .font(.customSubHeadline)
            
            if let message = config.type.message {
                Text(message)
                    .font(.customCaption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
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

extension AlertDialog {
    public static func info(title: String, message: String) -> AlertDialog {
        let primaryButton = ButtonConfig(type: .primary(title: "OK")) { _ in
        }
        let type = Type.info(title: title, message: message)
        let config = Config(type: type, image: "folder.fill.badge.plus", buttons: [primaryButton])
       
        return AlertDialog(config: config)
    }
    
    public static func confirm(title: String, message: String) -> AlertDialog {
        let primaryButton = ButtonConfig(type: .primary(title: "OK")) { _ in
        }
        let secondaryButton = ButtonConfig(type: .secondary(title: "Cancel")) { _ in
        }
        let type = Type.info(title: title, message: message)
        let config = Config(type: type, image: "folder.fill.badge.plus", buttons: [primaryButton, secondaryButton])
       
        return AlertDialog(config: config)
    }
    
    public static func error(message: String) -> AlertDialog {
        let primaryButton = ButtonConfig(type: .primary(title: "OK")) { _ in
        }
        let type = Type.error(message: message)
        let config = Config(type: type, image: "folder.fill.badge.plus", buttons: [primaryButton])
       
        return AlertDialog(config: config)
    }
    
    public static func success(message: String) -> AlertDialog {
        let primaryButton = ButtonConfig(type: .primary(title: "OK")) { _ in
        }
        let type = Type.success(message: message)
        let config = Config(type: type, image: "folder.fill.badge.plus", buttons: [primaryButton])
       
        return AlertDialog(config: config)
    }
}
