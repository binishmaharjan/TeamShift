import Observation

@Observable
public final class ToastHandler: Sendable {
    public init() { }
    
    @MainActor
    public private(set) var currentToastMessage: String?
    @MainActor @ObservationIgnored private var toastQueue: [String] = []
    @MainActor @ObservationIgnored private var currentToastShowingTask: Task<Void, Never>?
    
    private var toastShowingDuration: Duration {
        .seconds(3)
    }
    
    private var defaultToastHidingDuration: Duration {
        .milliseconds(450)
    }
    
    @MainActor
    public func queueMessage(_ message: String) {
        removeCurrentToast()
        toastQueue.append(message)
        displayNextToastIfAvailable()
    }
    
    @MainActor
    public func skipCurrent(in duration: Duration) {
        removeCurrentToast()
        Task {
            try? await Task.sleep(for: duration)
            displayNextToastIfAvailable()
        }
    }
}

// MARK: Private Methods
extension ToastHandler {
    @MainActor
    private func displayNextToastIfAvailable() {
        guard currentToastMessage == nil, let message = toastQueue.first else {
            return
        }
        
        toastQueue.removeFirst()
        currentToastMessage = message
        
        currentToastShowingTask?.cancel()
        currentToastShowingTask = Task {
            do {
                try await Task.sleep(for: toastShowingDuration)
                if Task.isCancelled { return }
                skipCurrent(in: defaultToastHidingDuration)
            } catch {
                print("❌ Toast: Task.sleep failed. Try Again")
            }
        }
    }
    
    @MainActor
    private func removeCurrentToast() {
        if currentToastMessage == nil { return }
        currentToastShowingTask?.cancel()
        currentToastMessage = nil
    }
}
