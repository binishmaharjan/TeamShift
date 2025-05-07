import SwiftUI

// MARK: Back Button
private  struct BackButton: View {
    init(backButtonImage: Image, action: @escaping () -> Void) {
        self.backButtonImage = backButtonImage
        self.action = action
    }
    
    private let backButtonImage: Image
    private let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            backButtonImage
                .renderingMode(.template)
        }
        .foregroundStyle(Color.appPrimary)
        .font(.customHeadline)
    }
}

private struct BackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButtonImage: Image
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(backButtonImage: backButtonImage) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
}

extension View {
    public func withCustomBackButton(image: Image = .icnBack) -> some View {
        modifier(BackButtonModifier(backButtonImage: image))
    }
}
