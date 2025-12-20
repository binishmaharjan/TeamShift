import SharedUIs
import SwiftUI
import UIKit

final class LicenseViewController: UIViewController {
    let viewModel: LicenseViewModel
    
    init(viewModel: LicenseViewModel) {
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
        view.backgroundColor = Color.backgroundList.uiColor
        let swiftUIView = LicenseView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
}


