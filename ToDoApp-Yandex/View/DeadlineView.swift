import UIKit

class DeadlineViewControl: UIControl {
    
    let deadlineView: UIView = {
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
    
    let calendarLabel: UILabel = {
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
        addSubview(deadlineView)
        deadlineView.addSubview(stackView)
        
        stackView.addArrangedSubview(secondLabel)
        stackView.addArrangedSubview(calendarLabel)
        
        stackView.backgroundColor = .blue
        NSLayoutConstraint.activate([
            calendarLabel.heightAnchor.constraint(equalToConstant: 18),
            deadlineView.topAnchor.constraint(equalTo: topAnchor),
            deadlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            deadlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            deadlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: deadlineView.topAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: deadlineView.trailingAnchor, constant: -90),
            stackView.bottomAnchor.constraint(equalTo: deadlineView.bottomAnchor, constant: -10)
        ])
    }
    
    func toggleCalendarLabelVisibility(_ isVisible: Bool) {
        calendarLabel.isHidden = !isVisible
    }
    
    func updateCalendarLabel(withDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        calendarLabel.text = dateString
    }
}
