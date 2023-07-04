import Foundation

struct ToDoItem{
    let id: String
    let title: String
    let importance: priority
    let deadline: Date?
    var isCompleted: Bool
    let createdDate: Date
    let changedDate: Date?
}
enum priority: String{
    case unimportant = "неважная"
    case regular = "обычная"
    case important = "важная"
}




