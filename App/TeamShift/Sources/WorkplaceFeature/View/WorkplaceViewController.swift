import SharedUIs
import SwiftUI
import UIKit

final class WorkplaceViewController: UIViewController {
    let viewModel: WorkplaceViewModel
    
    init(viewModel: WorkplaceViewModel) {
        self.viewModel = viewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { [viewModel] in
            await viewModel.send(action: .onAppear)
        }
    }
    
    private func setUpView() {
        view.backgroundColor = Color.backgroundPrimary.uiColor
        let swiftUIView = WorkplaceView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
    
    private func setUpNavigation() {
        let action = UIAction { [weak self] _ in
            self?.viewModel.addWorkplaceButtonTapped()
        }
        let image = UIImage(named: "icn_store_add", in: Bundle.sharedUIs, with: nil)?.withRenderingMode(.alwaysTemplate)
        let button = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        button.primaryAction = action
        button.tintColor = Color.appPrimary.uiColor
        navigationItem.rightBarButtonItem = button
    }
}


