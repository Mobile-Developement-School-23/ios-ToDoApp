//
//  Extension.swift
//  ToDoApp-Yandex
//
//  Created by Bekarys Shaimardan on 30.06.2023.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of cells you want to display
        return fileCache.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.radioButton.isSelected = false
        cell.textLabel?.attributedText = nil
        
        let item = fileCache.items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.radioButton.isSelected = item.isCompleted

        if item.isCompleted {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor(named: "ColorGray")!,
                .foregroundColor: UIColor(named: "ColorGray")!
            ]
            let attributedText = NSAttributedString(string: cell.textLabel?.text ?? "", attributes: textAttributes)
            cell.textLabel?.attributedText = attributedText
        }

        return cell
    }




}
extension MainViewController: UITableViewDelegate {
        
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//          return UITableView.automaticDimension
//        }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let longSwipeAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell
            let radioButton = cell?.radioButton

            let textAttributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor(named: "ColorGray")!,
                .foregroundColor: UIColor(named: "ColorGray")!
            ]
            let attributedText = NSAttributedString(string: cell?.textLabel?.text ?? "", attributes: textAttributes)
            cell?.textLabel?.attributedText = attributedText

            radioButton?.isSelected = true // Update the radio button condition
            var item = self.fileCache.items[indexPath.row]
            item.isCompleted = true;

            // Important: Update the item in your fileCache.items array
            self.fileCache.items[indexPath.row] = item
            self.fileCache.saveToJSONFile(named: "Tasks.geojson")
            print("Long swipe action performed")
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
            print("Info action performed")
            completionHandler(true)
        }
        swipeAction1.image = UIImage(systemName: "info.circle")
        swipeAction1.backgroundColor = UIColor(named: "ColorGray")
        
        let swipeAction2 = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            print("Delete action performed")
            self?.updateTableViewHeight()
            // Get the item to be removed
            let item = self?.fileCache.items[indexPath.row]
            
            // Remove the item from the FileCache
            self?.fileCache.removeItem(id: item?.id ?? "")
            
            // Save the updated items to the JSON file
            self?.fileCache.saveToJSONFile(named: "Tasks.geojson")
            
            // Animate the cell deletion
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: { _ in
                completionHandler(true)
            })
        }
        swipeAction2.image = UIImage(systemName: "trash.fill")
        swipeAction2.backgroundColor = UIColor(named: "ColorRed")
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction2, swipeAction1])
        configuration.performsFirstActionWithFullSwipe = true // for long swipe
        return configuration
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                tableView.reloadData()
                
    }

}
