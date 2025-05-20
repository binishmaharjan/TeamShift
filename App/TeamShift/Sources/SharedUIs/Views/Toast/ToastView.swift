import SwiftUI

struct ToastView: View {
    var toastHandler: ToastHandler
    
    private var toastHidingDuration: Duration {
        .milliseconds(10)
    }
    
    var body: some View {
        Group {
            if let toastMessage = toastHandler.currenToastMessage {
                Text(toastMessage)
                    .font(.customFootnote.bold())
                    .foregroundStyle(Color.background)
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.text.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 70)
                    .ignoresSafeArea()
            }
        }
        .animation(.easeInOut, value: toastHandler.currenToastMessage)
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
