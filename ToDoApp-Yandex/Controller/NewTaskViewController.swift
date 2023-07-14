import UIKit

class NewTaskViewController: UIViewController, UITextViewDelegate {
    var toDoItem : ToDoItem?
    var didSaveItem: ((ToDoItem) -> Void)?
    var didDeleteItem: ((ToDoItem) -> Void)?
    let dividerView = UIView()
    let grayDividerView = UIView()
    let stackView = UIStackView()
    let lineView = UIView()
    let scrollView = UIScrollView()
    let grayLineView = UIView()
    let saveButton = UIButton(type: .system)
    let calendarView = CalendarView()
    let secondView = DeadlineViewControl()
    let deleteButton = DeleteButton()
    let miniTextView = TextView()
    let toggleSwitch = UISwitch()
    var selectedDate: Double?
    let segmentedControl = SegmentedControlView()
    override func viewDidLoad() {
        super.viewDidLoad()
        miniTextView.delegate = self
        if (toDoItem?.importance == .important){
            segmentedControl.selectedSegmentIndex = 2;
        }else if (toDoItem?.importance == .low){
            segmentedControl.selectedSegmentIndex = 0;
        }else{
            segmentedControl.selectedSegmentIndex = 1;
        }
        if toDoItem?.id != ""{
            miniTextView.text = toDoItem?.text
            deleteButton.isEnabled = true
            deleteButton.buttonLabel.textColor = UIColor(named: "ColorRed")
        }
        if toDoItem?.deadline != 0{
            toggleSwitch.isOn = true
            secondView.toggleCalendarLabelVisibility(true)
            secondView.updateCalendarLabel(withDate: Date(timeIntervalSince1970: toDoItem?.deadline ?? Date().timeIntervalSince1970))
        }
        miniTextView.isScrollEnabled = false
        
        scrollView.backgroundColor = UIColor(named: "BackPrimary")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let customNavigationBar = setupNavigationBar()
        scrollView.addSubview(customNavigationBar)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            customNavigationBar.topAnchor.constraint(equalTo: scrollView.topAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 56)
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 72).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
//        let maximumStackViewHeight: CGFloat = traitCollection.verticalSizeClass == .compact ? 200 : 650
//        let maximumStackViewHeightConstraint = stackView.heightAnchor.constraint(lessThanOrEqualToConstant: maximumStackViewHeight)
//
//        maximumStackViewHeightConstraint.isActive = true
        
        stackView.addArrangedSubview(miniTextView)
        
        let importanceView = ImportanceView()
        stackView.addArrangedSubview(importanceView)
        
        importanceView.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: -142),
            segmentedControl.centerYAnchor.constraint(equalTo: importanceView.centerYAnchor)
        ])
        
        // Create the line view
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor(named: "BackSecondary")
        stackView.addArrangedSubview(lineView)
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        grayLineView.backgroundColor = UIColor(named: "SupportSeperator")
        lineView.addSubview(grayLineView)
        grayLineView.translatesAutoresizingMaskIntoConstraints = false
        grayLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        grayLineView.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 16).isActive = true
        grayLineView.trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: -16).isActive = true
        
        // Add the line view to the superview of stackView
        secondView.layer.cornerRadius = 15
        secondView.clipsToBounds = true
        secondView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        stackView.addArrangedSubview(secondView)
        
        
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        secondView.addSubview(toggleSwitch)
        NSLayoutConstraint.activate([
            toggleSwitch.leadingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -82),
            toggleSwitch.centerYAnchor.constraint(equalTo: secondView.centerYAnchor)
        ])
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchValueChanged), for: .valueChanged)
        
        stackView.addArrangedSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
//        deleteButton.isEnabled = false
        
        stackView.addArrangedSubview(deleteButton)
        stackView.setCustomSpacing(16.0, after: miniTextView)
        stackView.setCustomSpacing(0, after: importanceView)
        stackView.setCustomSpacing(0, after: lineView)
        stackView.setCustomSpacing(16.0, after: secondView)
    }
    
    @objc func toggleSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            dividerView.translatesAutoresizingMaskIntoConstraints = false
            dividerView.backgroundColor = UIColor(named: "BackSecondary")
            stackView.addArrangedSubview(dividerView)
            dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            
            grayDividerView.backgroundColor = UIColor(named: "SupportSeperator")
            dividerView.addSubview(grayDividerView)
            grayDividerView.translatesAutoresizingMaskIntoConstraints = false
            grayDividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            grayDividerView.leadingAnchor.constraint(equalTo: dividerView.leadingAnchor, constant: 16).isActive = true
            grayDividerView.trailingAnchor.constraint(equalTo: dividerView.trailingAnchor, constant: -16).isActive = true
            
            // Change the corner radius of the secondView to zero
            secondView.layer.cornerRadius = 0
            secondView.toggleCalendarLabelVisibility(sender.isOn)
            let initialDate = calendarView.datePicker.date
            secondView.updateCalendarLabel(withDate: initialDate)
            
            selectedDate = initialDate.timeIntervalSince1970
            // Create and display the pop-up calendar view
            calendarView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(calendarView)
            calendarView.layer.cornerRadius = 15
            calendarView.clipsToBounds = true
            calendarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            NSLayoutConstraint.activate([
                calendarView.topAnchor.constraint(equalTo: secondView.bottomAnchor),
                calendarView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
                calendarView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor),
            ])
            
            calendarView.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(deleteButton)
            
            NSLayoutConstraint.activate([
                deleteButton.heightAnchor.constraint(equalToConstant: 56),
            ])
            
            stackView.setCustomSpacing(16.0, after: calendarView)
            
            view.bringSubviewToFront(calendarView)
        } else {
            secondView.layer.cornerRadius = 15
            
            calendarView.removeFromSuperview()
            dividerView.removeFromSuperview()
            grayDividerView.removeFromSuperview()
            secondView.toggleCalendarLabelVisibility(false)
        }
    }
    
    
    
    internal func textViewDidChange(_ textView: UITextView) {
        let isTextViewEmpty = miniTextView.text.isEmpty
        saveButton.isEnabled = !isTextViewEmpty
        saveButton.setTitleColor(saveButton.isEnabled ? UIColor(named: "ColorBlue") : UIColor(named: "ColorGray"), for: .normal)
        deleteButton.buttonLabel.textColor = isTextViewEmpty ? UIColor(named: "ColorGray") : UIColor(named: "ColorRed")

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "ColorLightTertiary") {
            textView.text = nil
            textView.textColor = UIColor(named: "LabelPrimary")
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor(named: "ColorLightTertiary")
        }
    }
    func selectedPriority(segmentedControl: UISegmentedControl) -> priority{
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return .low
        case 1:
            return .basic
        case 2:
            return .important
        default:
            return .basic
        }
    }
    
    private func setupNavigationBar() -> UIView {
        let customNavigationBar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 56))
        customNavigationBar.backgroundColor = UIColor(named: "ColorLightTertiary")
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: customNavigationBar.frame.size.width, height: customNavigationBar.frame.size.height))
        titleLabel.textAlignment = .center
        titleLabel.text = "Дело"
        titleLabel.textColor = .label
        customNavigationBar.addSubview(titleLabel)
        customNavigationBar.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor, constant: -10),
            saveButton.centerYAnchor.constraint(equalTo: customNavigationBar.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 110),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        saveButton.isEnabled = !miniTextView.text.isEmpty && miniTextView.text != "Что надо сделать?"
        saveButton.setTitleColor(UIColor(named: "labelColor"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        customNavigationBar.addSubview(saveButton)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 15, y: (customNavigationBar.frame.size.height - 30) / 2, width: 110, height: 30)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancelButton.setTitleColor(UIColor.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        customNavigationBar.addSubview(cancelButton)
        
        return customNavigationBar
    }
    func createNewItem() -> ToDoItem{
        let priority = selectedPriority(segmentedControl: segmentedControl)
        let id: String
        if toDoItem?.id == ""{
            id = UUID().uuidString
        }else{
            id = toDoItem?.id ?? ""
        }
        if let dd = selectedDate{
            selectedDate = dd
        }else{
            selectedDate = toDoItem?.deadline
        }
        let newItem = ToDoItem(id: id, text: miniTextView.text, importance: priority, deadline: selectedDate ?? 0, done: toDoItem?.done ?? false, created_at: Double(Int64(Date().timeIntervalSince1970)), changed_at: Double(Int64(Date().timeIntervalSince1970)), last_updated_by: "Beka's iPhone")
        return newItem
    }
    @objc func saveButtonTapped() {
        let newItem = createNewItem()
        didSaveItem?(newItem)
        dismiss(animated: true, completion: nil)
    }
    @objc func deleteButtonTapped() {
        let newItem = createNewItem()
        didDeleteItem?(newItem)
       // print("Delete")
        dismiss(animated: true, completion: nil)
    }
                            
                               
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func datePickerValueChanged() {
        selectedDate = calendarView.datePicker.date.timeIntervalSince1970
        if let unwrappedDate = selectedDate {
            secondView.updateCalendarLabel(withDate: Date(timeIntervalSince1970: unwrappedDate))
        }
        
        if let dayView = calendarView.datePicker.subviews.first?.subviews.first(where: { String(describing: type(of: $0)) == "UIDatePickerDayView" }) {
            if let dayLabel = dayView.subviews.first?.subviews.first(where: { $0 is UILabel }) as? UILabel {
                for subview in dayView.subviews {
                    if let label = subview as? UILabel {
                        label.textColor = UIColor(named: "ColorBlue")
                    }
                }
                dayLabel.textColor = .white
            }
        }
    }
}
