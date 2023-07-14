import UIKit

class ImportanceView: UIView {
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Важность"
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImportanceView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImportanceView()
    }
    
    private func setupImportanceView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        backgroundColor = UIColor(named: "BackSecondary")
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addSubview(firstLabel)  // Add the firstLabel as a subview of the FirstView instance
        NSLayoutConstraint.activate([
            firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
