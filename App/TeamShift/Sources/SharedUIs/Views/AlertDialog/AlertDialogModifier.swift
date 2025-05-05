import SwiftUI

// Link: https://www.youtube.com/watch?v=Fa_d661SBrA
// MARK: Modifier
private struct AlertDialogModifier<AlertContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder var alertContent: AlertContent

    // View Properties
    @State private var showFullScreenCover: Bool = false
    @State private var animatedValue: Bool = false
    @State private var allowsInteraction: Bool = false
    
    @ViewBuilder
    private var background: some View {
        Rectangle()
            .fill(Color.black.opacity(0.35))
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $showFullScreenCover) {
                ZStack {
                    if animatedValue {
                        alertContent
                            .allowsHitTesting(allowsInteraction)
                    }
                }
                .presentationBackground {
                    background.opacity(animatedValue ? 1 : 0)
                        .allowsHitTesting(allowsInteraction)
                }
                .task {
                    try? await Task.sleep(for: .seconds(0.05))
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animatedValue = true
                    }
                    
                    try? await Task.sleep(for: .seconds(0.05))
                    allowsInteraction = true
                }
            }
            .onChange(of: isPresented) { _, newValue in
                // disable default animation
                var transaction = Transaction()
                transaction.disablesAnimations = true
                
                if newValue {
                    withTransaction(transaction) {
                        showFullScreenCover = true
                    }
                } else {
                    allowsInteraction = false
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animatedValue = false
                    } completion: {
                        // remove fullscreen without animation
                        withTransaction(transaction) {
                            showFullScreenCover = false
                        }
                    }
                }
            }
    }
}

extension View {
    @ViewBuilder
    public func alert(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> AlertDialog
    ) -> some View {
        self.modifier(
            AlertDialogModifier(
                isPresented: isPresented,
                alertContent: content
            )
        )
    }
}
