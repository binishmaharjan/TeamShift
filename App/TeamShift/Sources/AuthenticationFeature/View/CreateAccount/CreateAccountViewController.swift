import SharedUIs
import SwiftUI
import UIKit

final class CreateAccountViewController: UIViewController {
    let viewModel: CreateAccountViewModel
    
    init(viewModel: CreateAccountViewModel) {
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
        let swiftUIView = CreateAccountView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
}


