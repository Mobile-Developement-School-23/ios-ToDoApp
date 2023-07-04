import UIKit

class RadioButton: UIButton {
    let selectedImageName = "checkmark.circle.fill"
    let deselectedImageName = "circle"
    let buttonSize: CGFloat = 24

    override init(frame: CGRect) {
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        super.init(frame: buttonFrame)

        configureButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureButton()
    }

    func configureButton() {
        let selectedSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .regular, scale: .default)
        let deselectedSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .regular, scale: .default)

        let selectedSymbol = UIImage(systemName: selectedImageName, withConfiguration: selectedSymbolConfiguration)?.withTintColor(UIColor(named: "ColorGreen")!, renderingMode: .alwaysOriginal)
        let deselectedSymbol = UIImage(systemName: deselectedImageName, withConfiguration: deselectedSymbolConfiguration)?.withTintColor(UIColor(named: "SupportSeperator")!, renderingMode: .alwaysOriginal)

        setImage(deselectedSymbol, for: .normal)
        setImage(selectedSymbol, for: .selected)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView?.frame = bounds
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: buttonSize, height: buttonSize)
    }

    @objc func buttonTapped() {
        isSelected.toggle()
    }
}
