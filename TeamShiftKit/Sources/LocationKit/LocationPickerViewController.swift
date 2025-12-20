import SharedModels
import SharedUIs
import SwiftUI
import UIKit

public final class LocationPickerViewController: UIViewController {
    private let onLocationSelected: ((Coordinate?) -> Void)?
    private let onClose: (() -> Void)?
    
    public init(onLocationSelected: ((Coordinate?) -> Void)? = nil, onClose: (() -> Void)? = nil) {
        self.onLocationSelected = onLocationSelected
        self.onClose = onClose
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        view.backgroundColor = Color.backgroundPrimary.uiColor
        let swiftUIView = LocationPicker(onLocationSelected: onLocationSelected, onClose: onClose)
        addSubSwiftUIView(swiftUIView, to: view)
    }
}


