import Foundation


extension ToDoItem{
    static func parse(csv: String) -> ToDoItem?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"

        
        
        let item = csv.components(separatedBy: ",")
        if item.count != 7{
            return nil
        }
        let isCompletedString = item[4]
        let createdDateString = item[5]
        
        let id = item[0].isEmpty ? UUID().uuidString : item[0]
        
        let title = item[1]
        guard let isCompleted = Bool(isCompletedString)
        else{
            print(isCompletedString)
            return nil
        }
        let importanceString = item[2]
        
        let importance = importanceString != "обычная" ? priority(rawValue: importanceString) ?? .regular : .regular
        
        let deadlineString = item[3]
        let deadline = dateFormatter.date(from: deadlineString)
        
        guard let createdDate = dateFormatter.date(from: createdDateString)
        else{
            return nil
        }
        let changedDateString = item[6]
        let changedDate = dateFormatter.date(from: changedDateString)
        let newToDoItem = ToDoItem(id: id, title: title, importance: importance, deadline: deadline, isCompleted: isCompleted, createdDate: createdDate, changedDate: changedDate)
        return newToDoItem
    }
    
    var csv: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"
        
        let itemId = id.isEmpty ? UUID().uuidString : id
  
        
        let itemImportance: String
        if importance != .regular {
            itemImportance = importance.rawValue
        } else {
            itemImportance = ""
        }
        
        
        var csvString = "\(itemId),\(title),\(itemImportance),"
        if let deadline = deadline {
            let deadlineString = dateFormatter.string(from: deadline)
            csvString += "\(deadlineString),"
        } else {
            csvString += ","
        }
        csvString += "\(isCompleted),"
        
        
       let createdDateString = dateFormatter.string(from: createdDate)
       csvString += "\(createdDateString),"
        
        
        if let changedDate = changedDate {
        let changedDateString = dateFormatter.string(from: changedDate)
        csvString += "\(changedDateString)"
        }
        return csvString
    }
}

   
