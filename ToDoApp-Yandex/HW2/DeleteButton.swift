import UIKit
class DeleteButton: UIControl {
    let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDeleteButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDeleteButton()
    }
    
    private func setupDeleteButton() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        backgroundColor = UIColor(named: "BackSecondary")
        layer.cornerRadius = 15
        
        addSubview(buttonLabel)
        NSLayoutConstraint.activate([
            buttonLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
