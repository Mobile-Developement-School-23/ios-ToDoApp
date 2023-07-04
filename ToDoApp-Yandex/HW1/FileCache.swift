import Foundation

final class FileCache {

    enum Constants {
        static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    var items: [ToDoItem] = []
    
    func addItem(item: ToDoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    func removeItem(id: String) {
        items.removeAll { $0.id == id }
    }
    
    func saveToJSONFile(named fileName: String = "Items") {
        guard let fileURL = Constants.documentDirectory?.appendingPathComponent(fileName)
        else {
            return
        }
        
        let jsonArray = items.map { item -> Any in
            return item.json
        }
        
        guard let fileData = try? JSONSerialization.data(withJSONObject: jsonArray) else {
            return
        }
        
        try? fileData.write(to: fileURL)
    }
    
    func loadFromJSONFile(named fileName: String = "Items") -> [ToDoItem] {
        let fileURL = Constants.documentDirectory?.appendingPathComponent(fileName)
        
        guard let fileData = try? Data(contentsOf: fileURL!),
              let jsonArray = try? JSONSerialization.jsonObject(with: fileData) as? [[String: Any]]
        else {
            return []
        }
        
        let newItems = jsonArray.compactMap { jsonDict -> ToDoItem? in
            return ToDoItem.parse(json: jsonDict)
        }
        
        return newItems
    }
    
    func saveItemsToCSVFile(named fileName: String) {
        let csvRows = items.map { $0.csv }
        let csvString = csvRows.joined(separator: "\n")
        let filePath = Constants.documentDirectory?.appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: filePath!, atomically: true, encoding: .utf8)
            print("Items saved to CSV file successfully.")
        } catch {
            print("Error saving items to CSV file: \(error)")
        }
    }
    
    func loadFromCSVFile(named fileName: String) -> [ToDoItem] {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "csv") else {
            print("CSV file not found.")
            return []
        }
        
        guard let csvString = try? String(contentsOf: fileURL, encoding: .utf8) else {
            print("Failed to read CSV file.")
            return []
        }
        
        let rows = csvString.components(separatedBy: "\n")
        var loadedItems: [ToDoItem] = []
        
        for row in rows {
            let item = ToDoItem.parse(csv: row)
            if let item = item {
                loadedItems.append(item)
            }
        }
        
        return loadedItems
    }
}
