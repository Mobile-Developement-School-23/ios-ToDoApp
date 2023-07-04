import UIKit

class CustomView: UIControl {
    
    let secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 66).isActive = true
        view.backgroundColor = UIColor(named: "BackSecondary")
        
        return view
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сделать до"
        label.textColor = .label
        label.backgroundColor = UIColor(named: "BackSecondary")
        return label
    }()
    
    let additionalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.font = UIFont(name: "SF Pro Text", size: 13)
        label.isHidden = true
        label.backgroundColor = UIColor(named: "BackSecondary")
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(secondView)
        secondView.addSubview(stackView)
        
        stackView.addArrangedSubview(secondLabel)
        stackView.addArrangedSubview(additionalLabel)
        
        stackView.backgroundColor = .blue
        NSLayoutConstraint.activate([
            additionalLabel.heightAnchor.constraint(equalToConstant: 18),
            secondView.topAnchor.constraint(equalTo: topAnchor),
            secondView.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: trailingAnchor),
            secondView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -90),
            stackView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -10)
        ])
    }
    
    func toggleAdditionalLabelVisibility(_ isVisible: Bool) {
        additionalLabel.isHidden = !isVisible
    }
    
    func updateAdditionalLabel(withDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        additionalLabel.text = dateString
    }
}
