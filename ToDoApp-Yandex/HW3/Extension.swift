import Foundation
import UIKit

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let item = visibleItems[indexPath.row]
     //print("!!!!!!!\(visibleItems)")
        cell.isRadioButtonSelected = item.done
        cell.titleLabel.attributedText = nil
        cell.titleLabel.text = item.text
        if item.importance == .low{
            cell.imageView1.isHidden = false
            cell.imageView1.image = UIImage(systemName: "arrow.down")
        }else if item.importance == .important{
            cell.imageView1.isHidden = false
            cell.imageView1.image = UIImage(systemName: "exclamationmark.2")!.withTintColor(.red, renderingMode: .alwaysOriginal)
        }else{
            cell.imageView1.isHidden = true
        }
        if item.deadline != nil{
            let dateString = dateFormatter.string(from: item.deadline!)
            cell.deadlineLabel.text = dateString
            cell.deadlineView.isHidden = false
        }else{
            cell.deadlineView.isHidden = true
        }
            
        
        if  item.done {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor(named: "ColorGray")!,
                .foregroundColor: UIColor(named: "ColorGray")!
            ]
            let attributedText = NSAttributedString(string: cell.titleLabel.text ?? "", attributes: textAttributes)
            cell.titleLabel.attributedText = attributedText
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
        }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let longSwipeAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as? TableViewCell
            self.fileCache.items[indexPath.row].done = true
            self.fileCache.saveToJSONFile(named: "Tasks.geojson")
            cell?.isRadioButtonSelected = true
            let textAttributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor(named: "ColorGray")!,
                .foregroundColor: UIColor(named: "ColorGray")!
            ]
            let attributedText = NSAttributedString(string: cell?.titleLabel.text ?? "", attributes: textAttributes)
            cell?.titleLabel.attributedText = attributedText
            self.updateCounterLabel()
           // print("Long swipe action performed")
            completionHandler(true)
        }
        
        longSwipeAction.image = UIImage(systemName: "checkmark.circle.fill")
        longSwipeAction.backgroundColor = UIColor(named: "ColorGreen")
        
        let configuration = UISwipeActionsConfiguration(actions: [longSwipeAction])
        configuration.performsFirstActionWithFullSwipe = true // for long swipe
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction1 = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
       //     print("Info action performed")
            completionHandler(true)
        }
        swipeAction1.image = UIImage(systemName: "info.circle")
        swipeAction1.backgroundColor = UIColor(named: "ColorGray")
        
        let swipeAction2 = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            let item = self?.fileCache.items[indexPath.row]
            self?.fileCache.removeItem(id: item?.id ?? "")
            self?.fileCache.saveToJSONFile(named: "Tasks.geojson")
            
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .left)
            }, completion: { _ in
                completionHandler(true)
            })
            self?.updateTableViewHeight()
            self?.updateCounterLabel()
        }
        swipeAction2.image = UIImage(systemName: "trash.fill")
        swipeAction2.backgroundColor = UIColor(named: "ColorRed")
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction2, swipeAction1])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.reloadData()
        }

}
