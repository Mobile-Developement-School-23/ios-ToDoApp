import Foundation
extension ToDoItem {
    // MARK: - Makes ToDoItem from JSON
    static func parse(json: Any) -> ToDoItem? {
        guard let jsonDict = json as? [String: Any] else {
            return nil
        }
        
        let id = jsonDict["id"] as? String
        
        guard
            let title = jsonDict["title"] as? String,
            let isCompleted = jsonDict["isCompleted"] as? Bool,
            let createdTimestamp = jsonDict["createdDate"] as? TimeInterval
        else {
            return nil
        }
        
        let createdDate = Date(timeIntervalSince1970: createdTimestamp)
        
        let importanceString = jsonDict["importance"] as? String
        let importance = priority(rawValue: importanceString ?? "") ?? .regular
        
        let deadlineTimestamp = jsonDict["deadline"] as? TimeInterval
        let deadline: Date?
        if let deadlineTimestamp = deadlineTimestamp {
            deadline = Date(timeIntervalSince1970: deadlineTimestamp)
        } else {
            deadline = nil
        }
        
        let changedTimestamp = jsonDict["changedDate"] as? TimeInterval
        let changedDate: Date?
        if let changedTimestamp = changedTimestamp {
            changedDate = Date(timeIntervalSince1970: changedTimestamp)
        } else {
            changedDate = nil
        }
        
        let item = ToDoItem(
            id: id ?? UUID().uuidString,
            title: title,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            createdDate: createdDate,
            changedDate: changedDate
        )
        
        return item
    }

    
    var json: Any {
        var jsonObject: [String: Any?] = [
            "id": id,
            "title": title,
            "isCompleted": isCompleted,
            "createdDate": createdDate.timeIntervalSince1970,
            "changedDate": changedDate?.timeIntervalSince1970
        ]

        if importance != .regular {
            jsonObject["importance"] = importance.rawValue
        }

        if let deadline = deadline {
            jsonObject["deadline"] = deadline.timeIntervalSince1970
        }

        return jsonObject
    }

}
