import UIKit

class TableViewCell: UITableViewCell {
    let controlView = UIControl()
    let radioButton = RadioButton()
    let imageView1 = UIImageView()
    let labelStackView = UIStackView()
    let titleLabel = UILabel()
    let deadlineView = UIView()
    let deadlineLabel = UILabel()
    let imageView2 = UIImageView()
    let calendarImageView = UIImageView()
    let calendarImage = UIImage(systemName: "calendar")
    var isRadioButtonSelected: Bool = false{
           didSet {
               radioButton.isSelected = isRadioButtonSelected
           }
       }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "BackSecondary")
        // Setup Control View
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        controlView.addSubview(radioButton)
        controlView.backgroundColor = UIColor(named: "BackSecondary")
        radioButton.backgroundColor = UIColor(named: "BackSecondary")
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: controlView.leadingAnchor),
            radioButton.trailingAnchor.constraint(equalTo: controlView.trailingAnchor),
            radioButton.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 6),
            radioButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -6)
        ])
        // Setup Image View 1
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.widthAnchor.constraint(equalToConstant: 16).isActive = true

        labelStackView.axis = .vertical
        labelStackView.backgroundColor = .black
        labelStackView.distribution = .fillEqually
        
        titleLabel.backgroundColor = UIColor(named: "BackSecondary")
        deadlineView.backgroundColor = UIColor(named: "BackSecondary")
        deadlineView.addSubview(calendarImageView)
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarImageView.centerYAnchor.constraint(equalTo: deadlineView.centerYAnchor),
            calendarImageView.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor),
            calendarImageView.widthAnchor.constraint(equalToConstant: 16),
            calendarImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        deadlineView.addSubview(deadlineLabel)
        calendarImageView.image = calendarImage
        deadlineLabel.backgroundColor = UIColor(named: "BackSecondary")
        deadlineLabel.textColor = UIColor(named: "LabelTertiary")
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deadlineLabel.centerYAnchor.constraint(equalTo: deadlineView.centerYAnchor),
            deadlineLabel.leadingAnchor.constraint(equalTo: calendarImageView.trailingAnchor),
            deadlineLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        titleLabel.numberOfLines = 3
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(deadlineView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
     //   labelStackView.widthAnchor.constraint(equalToConstant: 250).isActive = true

        // Setup Image View 2
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView2.image = UIImage(systemName: "chevron.right")
        
//        imageView2.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView2.widthAnchor.constraint(equalToConstant: 7).isActive = true

        // Setup StackView to hold all the views horizontally
        let stackView = UIStackView(arrangedSubviews: [controlView, imageView1, labelStackView, imageView2])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.backgroundColor = UIColor(named: "BackSecondary")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        controlView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true

        contentView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
