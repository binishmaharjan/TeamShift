import Observation
import SharedUIs
import SwiftUI
import UIKit

final class ChangeAvatarViewController: UIViewController {
    let viewModel: ChangeAvatarViewModel
    private var saveButton: UIBarButtonItem!
    
    init(viewModel: ChangeAvatarViewModel) {
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
        startObservingViewModel()
        updateSaveButtonEnabled()
    }
    
    private func setUpView() {
        view.backgroundColor = Color.backgroundPrimary.uiColor
        let swiftUIView = ChangeAvatarView(viewModel: viewModel)
        addSubSwiftUIView(swiftUIView, to: view)
    }
    
    private func setUpNavigation() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            Task {
                await self.viewModel.updateAvatar()
            }
        }
        saveButton = UIBarButtonItem(title: l10.commonButtonSave, primaryAction: action)
        saveButton.tintColor = Color.appPrimary.uiColor
        navigationItem.rightBarButtonItem = saveButton
    }
}

// MARK: ViewModel Observation
extension ChangeAvatarViewController {
    private func startObservingViewModel() {
        withObservationTracking {
            _ = viewModel.isSavedButtonEnabled
        } onChange: { [weak self] in
            Task { @MainActor in
                guard let self else { return }
                self.updateSaveButtonEnabled()
                self.startObservingViewModel()
            }
        }
    }
    
    private func updateSaveButtonEnabled() {
        saveButton?.isEnabled = viewModel.isSavedButtonEnabled
    }
}
