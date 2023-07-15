//
//  parsingSQL.swift
//  ToDoApp-Yandex
//
//  Created by Bekarys Shaimardan on 12.07.2023.
//

import Foundation
extension ToDoItem{
    static func parseSQL(from values: (id: String, text: String, importance: priority, deadline: TimeInterval, done: Int32, created_at: TimeInterval, changed_at: TimeInterval, last_updated_by: String?)) -> ToDoItem? {
            return ToDoItem(
                id: values.id,
                text: values.text,
                importance: values.importance,
                deadline: Date(timeIntervalSince1970: values.deadline).timeIntervalSince1970,
                done: values.done == 1,
                created_at: Date(timeIntervalSince1970: values.created_at).timeIntervalSince1970,
                changed_at: Date(timeIntervalSince1970: values.changed_at).timeIntervalSince1970,
                last_updated_by: values.last_updated_by ?? ""

            )
        }
    var sqlReplaceStatement: String {
        get {
            let id = id
            let text = text
            let doneValue = done ? 1 : 0
            let deadlineValue = deadline ?? 0
            let changedAtValue = changed_at

            let query = """
            REPLACE INTO Items (Id, Text, Importance, Deadline, Done, Created_At, Changed_At, Last_Updated_By)
            VALUES ('\(id)', '\(text)', '\(importance.rawValue)', \(deadlineValue), \(doneValue), \(created_at), \(changedAtValue), '\(String(describing: last_updated_by) )');
            """
            return query
        }
    }
}
