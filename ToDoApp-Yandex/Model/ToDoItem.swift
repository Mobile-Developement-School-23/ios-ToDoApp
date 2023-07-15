import Foundation
import UIKit
enum priority: String, Codable, Equatable{
    case low = "low"
    case basic = "basic"
    case important = "important"
}

struct ToDoItem: Codable, Equatable{
    let id: String
    let text: String
    let importance: priority
    let deadline: Double?
    var done: Bool
    var color: String?
    let created_at: Double
    let changed_at: Double
    var last_updated_by: String
}




