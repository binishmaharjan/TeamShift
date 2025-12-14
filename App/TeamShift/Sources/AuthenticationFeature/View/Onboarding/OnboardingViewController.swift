import SharedUIs
import SwiftUI
import UIKit

final class OnboardingViewController: UIViewController {
    let viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        let swiftUIView = OnboardingView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
}


