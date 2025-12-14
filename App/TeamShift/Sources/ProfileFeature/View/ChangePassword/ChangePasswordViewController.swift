import SharedUIs
import SwiftUI
import UIKit

final class ChangePasswordViewController: UIViewController {
    let viewModel: ChangePasswordViewModel
    
    init(viewModel: ChangePasswordViewModel) {
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
        view.backgroundColor = Color.backgroundPrimary.uiColor
        let swiftUIView = ChangePasswordView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
}


