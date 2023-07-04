import UIKit

class MainNavigationBar: UIView {
    var titleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set the background color
        backgroundColor = .black
        // Create the title label
        titleLabel = UILabel(frame: CGRect(x: 32, y: 44, width: frame.size.width - 32, height: frame.size.height))
        titleLabel.text = "Task"
        titleLabel.textColor = .red
        addSubview(titleLabel)
        
  //      cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
