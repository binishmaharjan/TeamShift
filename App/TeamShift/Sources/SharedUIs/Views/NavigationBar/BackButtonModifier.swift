import SwiftUI

// MARK: Back Button
private  struct BackButton: View {
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    private let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image.icnBack
                .renderingMode(.template)
        }
        .foregroundStyle(Color.appPrimary)
        .font(.customHeadline)
    }
}

private struct BackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
}

extension View {
    public func withCustomBackButton() -> some View {
        modifier(BackButtonModifier())
    }
}
