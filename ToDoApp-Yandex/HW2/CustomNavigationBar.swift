//import UIKit
//class CustomNavigationBar: UIView {
//    weak var viewController: UIViewController?
//    var titleLabel: UILabel!
//    var saveButton: UIButton!
//    var cancelButton: UIButton!
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        // Set the background color
//        backgroundColor = UIColor(named: "BackgroundColor")
//        
//        // Create the title label
////        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
////        titleLabel.textAlignment = .center
////        titleLabel.textColor = .label
////        addSubview(titleLabel)
//        
////        saveButton = UIButton(type: .system)
////        saveButton.frame = CGRect(x: frame.size.width - 125, y: (frame.size.height - 30) / 2, width: 110, height: 30)
////        saveButton.setTitle("Сохранить", for: .normal)
////        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
////        saveButton.isEnabled = false
////        saveButton.setTitleColor(UIColor(named: "labelColor"), for: .normal)
////        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
////        addSubview(saveButton)
//        
////        cancelButton = UIButton(type: .system)
////        cancelButton.frame = CGRect(x: frame.size.width - 380, y: (frame.size.height - 30) / 2, width: 110, height: 30)
////        cancelButton.setTitle("Oтменить", for: .normal)
////        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
////        cancelButton.setTitleColor(UIColor.systemBlue, for: .normal)
////        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
////        addSubview(cancelButton)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc func saveButtonTapped() {
//        print("Save Button Tapped")
//        
//        guard let viewController = viewController as? ViewController else {
//            return
//        }
//        
//
//        // Dismiss the view controller
//        viewController.dismiss(animated: true, completion: nil)
//    }
//
//    
//    @objc func cancelButtonTapped(sender: UIButton) {
//        sender.isSelected.toggle()
//        viewController?.dismiss(animated: true)
//        print("Cancel Button Tapped")
//        
//    }
//}
