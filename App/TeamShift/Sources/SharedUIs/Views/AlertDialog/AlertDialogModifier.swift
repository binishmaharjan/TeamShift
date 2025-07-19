import SwiftUI

// Link: https://www.youtube.com/watch?v=Fa_d661SBrA
// MARK: Modifier
private struct AlertDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    var alertConfig: AlertDialog.Config?

    // View Properties
    @State private var showFullScreenCover: Bool = false
    @State private var animatedValue: Bool = false
    @State private var allowsInteraction: Bool = false
    
    @ViewBuilder
    private var background: some View {
        Rectangle()
            .fill(Color.black.opacity(0.35))
    }
    
    @ViewBuilder
    private var alertContent: some View {
        if let alertConfig {
            AlertDialog(config: alertConfig)
        }
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
    public func appAlert(isPresented: Binding<Bool>, alertConfig: AlertDialog.Config?) -> some View {
        modifier(AlertDialogModifier(isPresented: isPresented, alertConfig: alertConfig))
    }
}

/*
 get, set method are sendable.
 but Binding is not since it is designed to be user on main thread
 so when changing the wrapped value, it basically means the you are trying to change something non thread safe(UI) on thread safe closure
 so adding Isolating to @MainActor to ensure that this operation only run on MainThread
 */
@MainActor
extension Binding where Value == AlertDialog.Config? {
    public var isPresented: Binding<Bool> {
        .init {
            wrappedValue != nil
        } set: { isPresented, transaction in
            guard !isPresented else { return }
            if wrappedValue != nil {
                self.transaction(transaction).wrappedValue = nil
            }
        }
    }
}
