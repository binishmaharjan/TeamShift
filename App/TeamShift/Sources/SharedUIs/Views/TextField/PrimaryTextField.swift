import SwiftUI

public struct PrimaryTextField<Field: Hashable>: View {
    public init(
        _ placeholder: String,
        icon: Image,
        text: Binding<String>,
        fieldIdentifier: Field,
        focusedField: FocusState<Field?>.Binding,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.placeholder = placeholder
        self.icon = icon
        self._text = text
        self.fieldIdentifier = fieldIdentifier
        self.focusedField = focusedField
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }

    @State private var isVisibilityOn: Bool = false
    @Binding private var text: String
    private let icon: Image
    private let placeholder: String
    private let fieldIdentifier: Field
    private var focusedField: FocusState<Field?>.Binding
    private var isSecure: Bool = false
    private let keyboardType: UIKeyboardType
    
    private var isCurrentlyFocused: Bool {
        focusedField.wrappedValue == fieldIdentifier
    }
    
    public var body: some View {
        HStack {
            icon
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))
            
            Group {
                if (!isVisibilityOn && isSecure) {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .font(.customFootnote)
            .focused(focusedField, equals: fieldIdentifier)
            
            if isSecure {
                (isVisibilityOn ? Image.icnVisibilityOff : Image.icnVisibilityOn)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))
                    .onTapGesture {
                        isVisibilityOn.toggle()
                        DispatchQueue.main.async {
                            focusedField.wrappedValue = fieldIdentifier
                        }
                    }
            }
        }
        .padding(13)
        .frame(height: 44)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(lineWidth: 1)
                .fill(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))
        }
        .animation(.easeOut(duration: 0.15), value: isCurrentlyFocused)
        .animation(.easeOut(duration: 0.15), value: isVisibilityOn)
    }
}
