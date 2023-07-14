import Foundation
import UIKit

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let item = visibleItems[indexPath.row]
        print(item.done)
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
        if (item.deadline != 0 && item.deadline != nil){
            let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: item.deadline!))
            cell.deadlineLabel.text = dateString
            cell.deadlineView.isHidden = false
        }else{
            cell.deadlineView.isHidden = true
        }
        if item.done {
            let textAttributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor(named: "ColorGray")!,
                .foregroundColor: UIColor(named: "ColorGray")!
            ]
            let attributedText = NSAttributedString(string: cell.titleLabel.text ?? "", attributes: textAttributes)
            cell.titleLabel.attributedText = attributedText
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let longSwipeAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as? TableViewCell
            
            var item = self.fileCache.items[indexPath.row];
            self.fileCache.items[indexPath.row].done = true
            item.done = true
            DispatchQueue.global(qos: .background).async {
                self.networkingService.updateTodoItem(withId: item.id, item: item) { result in
                    switch result{
                    case .success(let item):
                        print("Succesfully updated item: \(item)")
                    case .failure(let error):
                        print("Failed to update item: \(error)")
                    }
                }
            }
            self.fileCache.updateItem(id: item.id, item: item, named: "mock")
            cell?.isRadioButtonSelected = true
            let textAttributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor(named: "ColorGray")!,
                .foregroundColor: UIColor(named: "ColorGray")!
            ]
            let attributedText = NSAttributedString(string: cell?.titleLabel.text ?? "", attributes: textAttributes)
            cell?.titleLabel.attributedText = attributedText
            self.updateCounterLabel()

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
            DispatchQueue.global(qos: .background).async {
                self?.networkingService.deleteTodoItem(withID: item?.id ?? "") { result in
                    switch result {
                    case .success(_):
                        print("sucess")
                        
                    case .failure(_):
                        print("Failed to delete")
                    }
                }
            }
            DispatchQueue.main.async {
                self?.fileCache.removeItem(id: item?.id ?? "")
                self?.fileCache.deleteItem(id: "\(item?.id ?? "")", named: "mock")
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: [indexPath], with: .left)
                }, completion: { _ in
                    completionHandler(true)
                })
                self?.updateTableViewHeight()
                self?.updateCounterLabel()
            }
        }
        swipeAction2.image = UIImage(systemName: "trash.fill")
        swipeAction2.backgroundColor = UIColor(named: "ColorRed")
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction2, swipeAction1])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   print(indexPath.row)
        let newTaskVC = NewTaskViewController()
        let item = visibleItems[indexPath.row]
        let id = item.id
        let text = item.text
        let importance = item.importance
        let deadline = item.deadline
        let done = item.done
        let created_at = item.created_at
        let changed_at = item.changed_at
        newTaskVC.toDoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, done: done, created_at: created_at, changed_at: changed_at, last_updated_by: "Beka's iPhone")
        newTaskVC.didSaveItem = { [weak self] newItem in
            //            print(self?.networkingService.currentRevision)
            DispatchQueue.global(qos: .background).async {
                self?.networkingService.updateTodoItem(withId: newItem.id, item: newItem, completion: { result in
                    switch result{
                    case .success(_):
                        print("Succesfully updated new item")
                    case .failure(let error):
                        print("Failed to update new item : \(error)")
                    }
                })
            }
            DispatchQueue.main.async {
                self?.fileCache.addItem(item: newItem)
                self?.fileCache.deleteItem(id: "\(item.id)", named: "mock")
                tableView.reloadData()
                self?.updateTableViewHeight()
            }
            
        }
        print(id)
        newTaskVC.didDeleteItem = { [weak self] newItem in
            //  print("am i here")
            DispatchQueue.global(qos: .background).async {
                print(newItem.id)
                self?.networkingService.deleteTodoItem(withID: newItem.id , completion: { result in
                    switch result{
                    case .success(_):
                        print("Deleted toDoItem")
                    case .failure(_):
                        print("Failed to delete")
                    }
                }
                )
            }
            
            
            self?.fileCache.removeItem(id: newItem.id)
            self?.fileCache.deleteItem(id: newItem.id, named: "mock")
            tableView.reloadData()
            self?.updateTableViewHeight()
        }
        present(newTaskVC, animated: true)
        
        //            tableView.reloadData()
    }
    
}
