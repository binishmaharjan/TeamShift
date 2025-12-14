import SharedUIs
import SwiftUI
import UIKit

final class ProfileViewController: UIViewController {
    let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshUserData()
    }
    
    private func setUpView() {
        view.backgroundColor = Color.backgroundList.uiColor
        let swiftUIView = ProfileView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
}


