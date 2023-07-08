import UIKit

class CustomTableViewCell: UITableViewCell {
    var control: UIControl!
    let radioButton = RadioButton()
    let textLabelPadding: CGFloat = 12
    var textLabelHeightConstraint: NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        control = UIControl()
        radioButton.backgroundColor = UIColor(named: "BackSecondary")
        
        control.addSubview(radioButton)
        contentView.addSubview(control)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            control.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            control.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            control.widthAnchor.constraint(equalToConstant: 24),
            control.heightAnchor.constraint(equalToConstant: 24),
            
            radioButton.leadingAnchor.constraint(equalTo: control.leadingAnchor),
            radioButton.trailingAnchor.constraint(equalTo: control.trailingAnchor),
            radioButton.topAnchor.constraint(equalTo: control.topAnchor),
            radioButton.bottomAnchor.constraint(equalTo: control.bottomAnchor)
        ])
        self.textLabel?.numberOfLines = 3
                self.textLabel?.lineBreakMode = .byTruncatingTail
                self.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
                guard let textLabel = textLabel else{
                    return
                }
                NSLayoutConstraint.activate([
                    textLabel.leadingAnchor.constraint(equalTo: control.trailingAnchor, constant: textLabelPadding),
                    textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textLabelPadding),
                    textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textLabelPadding),
                    textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -textLabelPadding)
                ])
    }
    func updateVisibility(isHidden: Bool) {
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
