import UIKit

class SegmentedControlView: UISegmentedControl {
    private let items: [Any] = [
        UIImage(systemName: "arrow.down")!,
        "нет",
        UIImage(systemName: "exclamationmark.2")!.withTintColor(.red, renderingMode: .alwaysOriginal)
    ]
    
    private let defaultSelectedSegmentIndex: Int
    
    init(selectedSegmentIndex: Int = 0) {
        self.defaultSelectedSegmentIndex = selectedSegmentIndex
        super.init(items: items)
        setupSegmentedControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.defaultSelectedSegmentIndex = 0
        super.init(coder: aDecoder)
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        // Customize the appearance or behavior of the segmented control if needed
        self.translatesAutoresizingMaskIntoConstraints = false
        self.selectedSegmentIndex = defaultSelectedSegmentIndex
    }
}
