import SharedUIs
import SwiftUI
import UIKit

final class DeleteAccountViewController: UIViewController {
    let viewModel: DeleteAccountViewModel
    
    init(viewModel: DeleteAccountViewModel) {
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
        let swiftUIView = DeleteAccountView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
}


