import SwiftUI

public struct AlertDialog: View {
    public enum Kind: Sendable {
        case info(title: String, message: String?)
        case confirm(title: String, message: String?)
        case textField(title: String, message: String?, textHint: String?)
        case error(message: String?)
        case success(message: String?)
        
        var tint: Color {
            switch self {
            case .info, .confirm, .textField:
                return .appPrimary
                
            case .error:
                return .appError
                
            case .success:
                return .green00D159
            }
        }
        
        var foregroundColor: Color {
            .background
        }
        
        var title: String {
            switch self {
            case .info(let title, _), .confirm(let title, _), .textField(let title, _, _):
                return title
                
            case .error:
                return l10.commonAlertError
                
            case .success:
                return l10.commonAlertSuccess
            }
        }
        
        var message: String? {
            switch self {
            case .info(_, let message), .confirm(_, let message), .textField(_, let message, _),.error(let message), .success(let message):
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
        public init(kind: Kind, icnImage: Image, buttons: [ButtonConfig]) {
            self.kind = kind
            self.icnImage = icnImage
            self.buttons = buttons
        }
        
        var kind: Kind
        var icnImage: Image
        var buttons: [ButtonConfig]
    }
    
    var config: Config
    
    @State private var text: String = ""
    
    // MARK: Properties
    public var body: some View {
        VStack(spacing: 15) {
            config.icnImage
                .resizable()
                .scaledToFit()
                .padding(16)
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
            
            if case .textField(_, _, let textFieldHint) = config.kind {
                TextField(textFieldHint ?? "", text: $text)
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
            if case .textField = config.kind, case .primary = buttonConfig.type {
                buttonConfig.action?(text)
            } else {
                buttonConfig.action?(nil)
            }
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
    public static func info(title: String, message: String, primaryAction: (@Sendable () -> Void)?) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .info(title: title, message: message),
            icnImage: .icnInfo,
            buttons: [
                AlertDialog.ButtonConfig(type: .primary(title: l10.commonButtonOK)) { _ in primaryAction?() }
            ]
        )
    }
    
    public static func confirm(
        buttonTitle: String,
        title: String,
        message: String,
        primaryAction: (@Sendable () -> Void)?,
        secondaryAction: (@Sendable () -> Void)?
    ) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .info(title: title, message: message),
            icnImage: .icnInfo,
            buttons: [
                AlertDialog.ButtonConfig(type: .primary(title: buttonTitle)) { _ in primaryAction?() },
                AlertDialog.ButtonConfig(type: .secondary(title: l10.commonButtonCancel)) { _ in secondaryAction?() }
            ]
        )
    }
    
    public static func textField(
        title: String,
        message: String,
        textHint: String? = nil,
        primaryAction: (@Sendable (String?) -> Void)?,
        secondaryAction: (@Sendable () -> Void)?
    ) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .textField(title: title, message: message, textHint: textHint),
            icnImage: .icnInfo,
            buttons: [
                AlertDialog.ButtonConfig(type: .primary(title: l10.commonButtonOK)) { text in primaryAction?(text) },
                AlertDialog.ButtonConfig(type: .secondary(title: l10.commonButtonCancel)) { _ in secondaryAction?() }
            ]
        )
    }
    
    public static func error(message: String, primaryAction: (@Sendable () -> Void)?) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .error(message: message),
            icnImage: .icnError,
            buttons: [
                AlertDialog.ButtonConfig(type: .primary(title: l10.commonButtonOK)) { _ in primaryAction?() },
            ]
        )
    }
    
    public static func success(message: String, primaryAction: (@Sendable () -> Void)?) -> AlertDialog.Config {
        AlertDialog.Config(
            kind: .success(message: message),
            icnImage: .icnSuccess,
            buttons: [
                AlertDialog.ButtonConfig(type: .primary(title: l10.commonButtonOK)) { _ in primaryAction?() },
            ]
        )
    }
}
