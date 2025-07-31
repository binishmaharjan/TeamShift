import SwiftUI

public struct PrimaryTextField<Field: Hashable>: View {
    public enum Kind {
        case icon(image: Image)
        case secure(image: Image)
        case editor(height: CGFloat)
    }
    
    public init(
        _ placeholder: String,
        kind: Kind,
        text: Binding<String>,
        fieldIdentifier: Field,
        focusedField: FocusState<Field?>.Binding,
        keyboardType: UIKeyboardType = .default
    ) {
        self.placeholder = placeholder
        self.kind = kind
        self._text = text
        self.fieldIdentifier = fieldIdentifier
        self.focusedField = focusedField
        self.keyboardType = keyboardType
    }

    @State private var isVisibilityOn: Bool = false
    @Binding private var text: String
    private let kind: Kind
    private let placeholder: String
    private let fieldIdentifier: Field
    private var focusedField: FocusState<Field?>.Binding
    private let keyboardType: UIKeyboardType
    
    private var isCurrentlyFocused: Bool {
        focusedField.wrappedValue == fieldIdentifier
    }
    
    private var height: CGFloat {
        switch kind {
        case .icon, .secure:
            return 44
            
        case .editor(let height):
            return height
        }
    }
    
    public var body: some View {
        HStack {
            switch kind {
            case .icon(let image):
                image
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.customFootnote)
                    .focused(focusedField, equals: fieldIdentifier)
                
            case .secure(let image):
                image
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))

                Group {
                    if (!isVisibilityOn) {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(.customFootnote)
                .focused(focusedField, equals: fieldIdentifier)
                
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
                
            case .editor:
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .keyboardType(keyboardType)
                        .focused(focusedField, equals: fieldIdentifier)
                    
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundStyle(Color.textPrimary.opacity(0.3))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .allowsHitTesting(false)
                    }
                }
                .font(.customFootnote)
            }
        }
        .padding(13)
        .frame(height: height)
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

public struct LocationTextField<Field: Hashable>: View {
    public init(
        _ placeholder: String,
        image: Image,
        text: Binding<String>,
        fieldIdentifier: Field,
        focusedField: FocusState<Field?>.Binding,
        onTapped: @escaping (() -> Void)
    ) {
        self.placeholder = placeholder
        self.image = image
        self._text = text
        self.fieldIdentifier = fieldIdentifier
        self.focusedField = focusedField
        self.onTapped = onTapped
    }
    
    @Binding private var text: String
    private let placeholder: String
    private let fieldIdentifier: Field
    private var focusedField: FocusState<Field?>.Binding
    private var image: Image
    private var height: CGFloat = 44
    private var onTapped: (() -> Void)
    
    private var isCurrentlyFocused: Bool {
        focusedField.wrappedValue == fieldIdentifier
    }
    
    public var body: some View {
        HStack {
            image
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))
            
            TextField(placeholder, text: $text)
                .font(.customFootnote)
                .focused(focusedField, equals: fieldIdentifier)
            
            Image.icnLocation
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))
                .onTapGesture {
                    onTapped()
                    print("Show Picker")
                }
        }
        .padding(13)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(lineWidth: 1)
                .fill(isCurrentlyFocused ? Color.appPrimary : Color.textPrimary.opacity(0.3))
        }
        .animation(.easeOut(duration: 0.15), value: isCurrentlyFocused)
    }
}
