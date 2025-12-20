import SwiftUI

// MARK: Activity Indicator
public struct ActivityIndicator: View {
    public init() { }
    
    @State private var currentDegrees = 0.0
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    private let colorGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                Color.appSuccess,
                Color.appSuccess.opacity(0.75),
                Color.appSuccess.opacity(0.5),
                Color.appSuccess.opacity(0.2),
                .clear
            ]
        ),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.85)
            .stroke(colorGradient, style: StrokeStyle(lineWidth: 5))
            .frame(width: 40, height: 40)
            .rotationEffect(Angle(degrees: currentDegrees))
            .onReceive(timer) { _ in
                withAnimation {
                    currentDegrees += 10
                }
            }
    }
}

#Preview {
    ActivityIndicator()
}

// MARK: View + Extension
extension View {
    public func loadingView(_ isLoading: Bool) -> some View {
        overlay {
            ZStack {
                if isLoading {
                    ActivityIndicator()
                } else {
                    EmptyView()
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }
}
