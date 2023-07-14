import UIKit

class CalendarView: UIView {
    let datePicker: UIDatePicker
    
    override init(frame: CGRect) {
        datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "BackSecondary")
        layer.cornerRadius = 10
        clipsToBounds = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        let currentDate = Date()
        
        if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
            datePicker.date = nextDay
        }
    }

}
