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
        
        // Add the date picker to the view
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(datePicker)
        
        // Configure the date picker
        datePicker.datePickerMode = .date
        //datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        // Add constraints for the date picker
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        // Get the current date
        let currentDate = Date()
        
        // Calculate the next day
        if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
            // Set the date picker's initial value to the next day
            datePicker.date = nextDay
        }
    }
//    
//    @objc private func datePickerValueChanged() {
//        // Assuming you have a reference to the CustomView instance
//
//        // Assuming you have a reference to the selected date from the date picker
//        let selectedDate = datePicker.date
//
//        // Update the chosen date label in the CustomView
//    //      customView.updateAdditionalLabel(withDate: selectedDate)
//        let calendar = Calendar.current
//
//        if let dayView = datePicker.subviews.first?.subviews.first(where: { String(describing: type(of: $0)) == "UIDatePickerDayView" }) {
//            if let dayLabel = dayView.subviews.first?.subviews.first(where: { $0 is UILabel }) as? UILabel {
//                // Reset the color of all day labels
//                for subview in dayView.subviews {
//                    if let label = subview as? UILabel {
//                        label.textColor = .blue
//                    }
//                }
//
//                // Set the color of the selected day label
//                dayLabel.textColor = .white
//            }
//        }
//    }
}
