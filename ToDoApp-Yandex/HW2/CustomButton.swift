import UIKit

class CustomButton: UIButton {
    var firstSelector: Selector?
    var secondSelector: Selector?
    var thirdSelector: Selector?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    // MARK: - Button Action

    @objc private func buttonTapped() {
        if let selector = firstSelector {
            performSelector(onMainThread: selector, with: self, waitUntilDone: true)
        }
    }

    // MARK: - Custom Actions

    func setFirstSelector(_ selector: Selector) {
        firstSelector = selector
    }

    func setSecondSelector(_ selector: Selector) {
        secondSelector = selector
    }

    func setThirdSelector(_ selector: Selector) {
        thirdSelector = selector
    }
}
