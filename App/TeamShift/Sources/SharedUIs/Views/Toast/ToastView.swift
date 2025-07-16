import SwiftUI

struct ToastView: View {
    var toastHandler: ToastHandler
    
    private var toastHidingDuration: Duration {
        .milliseconds(10)
    }
    
    var body: some View {
        Group {
            if let toastMessage = toastHandler.currentToastMessage {
                Text(toastMessage)
                    .font(.customFootnote.bold())
                    .foregroundStyle(Color.backgroundPrimary)
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.textPrimary.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 10)
            }
        }
        .animation(.easeInOut, value: toastHandler.currentToastMessage)
        .onTapGesture {
            toastHandler.skipCurrent(in: toastHidingDuration)
        }
    }
}

extension View {
    public func displayToast(handledBy toastHandler: ToastHandler) -> some View {
        self.displayToast(
            on: .top,
            handledBy: toastHandler
        ) {
            ToastView(toastHandler: $0)
        }
    }
}
