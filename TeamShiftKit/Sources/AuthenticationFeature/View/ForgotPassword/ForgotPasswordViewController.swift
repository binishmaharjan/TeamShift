import SharedUIs
import SwiftUI
import UIKit

final class ForgotPasswordViewController: UIViewController {
    let viewModel: ForgotPasswordViewModel
    private let onClose: (() -> Void)?
    
    init(viewModel: ForgotPasswordViewModel, onClose: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onClose = onClose
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpNavigation()
    }
    
    private func setUpView() {
        view.backgroundColor = Color.backgroundPrimary.uiColor
        let swiftUIView = ForgotPasswordView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
    
    private func setUpNavigation() {
        let action = UIAction { [weak self] _ in
            self?.onClose?()
        }
        let image = UIImage(named: "icn_close", in: Bundle.sharedUIs, with: nil)?.withRenderingMode(.alwaysTemplate)
        let close = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        close.primaryAction = action
        close.tintColor = Color.appPrimary.uiColor
        navigationItem.rightBarButtonItem = close
    }
}


