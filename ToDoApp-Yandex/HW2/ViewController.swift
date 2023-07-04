import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    var didSaveItem: ((ToDoItem) -> Void)?
    let dividerView = UIView()
    let grayDividerView = UIView()
    let stackView = UIStackView()
    let lineView = UIView()
    let scrollView = UIScrollView()
    let grayLineView = UIView()
    let saveButton = UIButton(type: .system)
    let calendarView = CalendarView()
    let secondView = CustomView()
    let deleteButton = DeleteButton()
    let miniTextView = MiniTextView()
    let segmentedControl = SegmentedControlView(selectedSegmentIndex: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        miniTextView.delegate = self
        
        scrollView.backgroundColor = UIColor(named: "BackPrimary")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let customNavigationBar = setupNavigationBar()
        scrollView.addSubview(customNavigationBar)
        
        // Set constraints for the scroll view to occupy the whole screen
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            customNavigationBar.topAnchor.constraint(equalTo: scrollView.topAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 56) // Adjust the height as needed
        ])
        
        // Create a stack view as the container
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        
        // Set constraints for the stack view to fill the scroll view
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 72).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        let maximumStackViewHeight: CGFloat = traitCollection.verticalSizeClass == .compact ? 200 : 650
        let maximumStackViewHeightConstraint = stackView.heightAnchor.constraint(lessThanOrEqualToConstant: maximumStackViewHeight)
        
        // Activate the maximum height constraint
        maximumStackViewHeightConstraint.isActive = true
        
        stackView.addArrangedSubview(miniTextView)
        
        let importanceView = FirstView()
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
        
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        secondView.addSubview(toggleSwitch)
        NSLayoutConstraint.activate([
            toggleSwitch.leadingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -82),
            toggleSwitch.centerYAnchor.constraint(equalTo: secondView.centerYAnchor)
        ])
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchValueChanged), for: .valueChanged)
        
        stackView.addArrangedSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.isEnabled = false
        
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
            secondView.toggleAdditionalLabelVisibility(sender.isOn)
            let initialDate = calendarView.datePicker.date
            secondView.updateAdditionalLabel(withDate: initialDate)
            
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
            secondView.toggleAdditionalLabelVisibility(false)
        }
    }
    
    @objc func deleteButtonTapped() {
        print("Delete button tapped")
    }
    
    internal func textViewDidChange(_ miniTextView: UITextView) {
        let isTextViewEmpty = miniTextView.text.isEmpty
        
        saveButton.isEnabled = !isTextViewEmpty
        saveButton.setTitleColor(isTextViewEmpty ? UIColor(named: "ColorGray") : UIColor(named: "ColorBlue"), for: .normal)
        deleteButton.isEnabled = !isTextViewEmpty
        deleteButton.buttonLabel.textColor = isTextViewEmpty ? UIColor(named: "ColorGray") : .red
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
            return .unimportant
        case 1:
            return .regular
        case 2:
            return .important
        default:
            return .regular
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
        
        saveButton.frame = CGRect(x: customNavigationBar.frame.size.width - 125, y: (customNavigationBar.frame.size.height - 30) / 2, width: 110, height: 30)
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        saveButton.isEnabled = false
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
    
    @objc func saveButtonTapped() {
//        let segmentedControl = segmentedControl.selectedSegmentIndex // replace this with your actual segmented control
            let priority = selectedPriority(segmentedControl: segmentedControl)
        
        let newItem = ToDoItem(id: UUID().uuidString, title: miniTextView.text, importance: priority, deadline: nil, isCompleted: false, createdDate: Date(), changedDate: nil)
            
            // Call the didSaveItem closure if it's set
            didSaveItem?(newItem)
            
            // Dismiss the view controller
            dismiss(animated: true, completion: nil)
        print("Save Button Tapped")
        }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
        print("Cancel Button Tapped")
    }
    
    @objc private func datePickerValueChanged() {
        let selectedDate = calendarView.datePicker.date
        secondView.updateAdditionalLabel(withDate: selectedDate)
        
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
