import Foundation
import UIKit

struct ToDoItem: Codable{
    let id: String
    let text: String
    let importance: priority
    let deadline: Date?
    var done: Bool
    var color: String?
    let created_at: Date
    let changed_at: Date?
    let last_updated_by: String?
}
enum priority: String, Codable{
    case low = "low"
    case basic = "basic"
    case important = "important"
}




