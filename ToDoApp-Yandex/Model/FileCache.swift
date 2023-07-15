import Foundation
import SQLite3
final class FileCache {
    
    enum Constants {
        static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    var items: [ToDoItem] = []
    var db: OpaquePointer?
    
    // Открывает соединение с базой данных SQLite
    func openDatabase(named fileName: String = "Items") -> OpaquePointer? {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(fileName + ".sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        }
        
        return db
    }
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
    
//    // MARK: - Saves items to SQLite database
//    func save(named fileName: String = "Items") {
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
//        let db = openDatabase(named: fileName)
//        
//        let createTableString = """
//                                   CREATE TABLE IF NOT EXISTS Items(
//                                   Id TEXT PRIMARY KEY,
//                                   Text TEXT,
//                                   Importance TEXT,
//                                   Deadline REAL,
//                                   Done INTEGER,
//                                   Created_At REAL,
//                                   Changed_At REAL,
//                                   Last_Updated_By TEXT);
//                                   """
//        
//        var createTableStatement: OpaquePointer?
//        
//        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
//            if sqlite3_step(createTableStatement) == SQLITE_DONE {
//                //       print("Items table created.")
//            } else {
//                print("Items table could not be created.")
//            }
//        } else {
//            print("CREATE TABLE statement could not be prepared.")
//        }
//        
//        sqlite3_finalize(createTableStatement)
//        
//        // Delete all existing rows in the table
//        let deleteStatementString = "DELETE FROM Items;"
//        var deleteStatement: OpaquePointer?
//        
//        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
//            if sqlite3_step(deleteStatement) == SQLITE_DONE {
//                //        print("All rows deleted.")
//            } else {
//                print("Failed to delete rows.")
//            }
//        } else {
//            print("DELETE statement could not be prepared.")
//        }
//        
//        sqlite3_finalize(deleteStatement)
//        
//        items.forEach { item in
//            let insertStatementString = "INSERT INTO Items (Id, Text, Importance, Deadline, Done, Created_At, Changed_At, Last_Updated_By) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
//            var insertStatement: OpaquePointer?
//            
//            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//                sqlite3_bind_text(insertStatement, 1, (item.id as NSString).utf8String, -1, nil)
//                sqlite3_bind_text(insertStatement, 2, (item.text as NSString).utf8String, -1, nil)
//                sqlite3_bind_text(insertStatement, 3, (item.importance.rawValue as NSString).utf8String, -1, nil)
//                sqlite3_bind_double(insertStatement, 4, item.deadline ?? 0)
//                sqlite3_bind_int(insertStatement, 5, item.done ? 1 : 0)
//                sqlite3_bind_double(insertStatement, 6, item.created_at)
//                sqlite3_bind_double(insertStatement, 7, item.changed_at )
//                sqlite3_bind_text(insertStatement, 8, (item.last_updated_by as NSString?)?.utf8String ?? nil, -1, nil)
//                
//                if sqlite3_step(insertStatement) == SQLITE_DONE {
//                    //    print("Successfully inserted row.")
//                } else {
//                    print("Could not insert row.")
//                }
//            } else {
//                print("INSERT statement could not be prepared.")
//            }
//            
//            sqlite3_finalize(insertStatement)
//        }
//        
//        sqlite3_close(db)
//    }
//    
//    
    
    // MARK: - Loads items from SQLite database
    func load(named fileName: String = "Items") -> [ToDoItem] {
        let db = openDatabase(named: fileName)
        let queryStatementString = "SELECT * FROM Items;"
        var queryStatement: OpaquePointer?
        var items: [ToDoItem] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let text = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let importance = priority(rawValue: String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))) ?? .basic
                let deadline = sqlite3_column_double(queryStatement, 3)
                let done = sqlite3_column_int(queryStatement, 4)
                let created_at = sqlite3_column_double(queryStatement, 5)
                let changed_at = sqlite3_column_double(queryStatement, 6)
                let last_updated_by = sqlite3_column_text(queryStatement, 7)
                
                items.append(ToDoItem(
                    id: id,
                    text: text,
                    importance: importance,
                    deadline: Date(timeIntervalSince1970: deadline).timeIntervalSince1970,
                    done: done == 1,
                    created_at: Date(timeIntervalSince1970: created_at).timeIntervalSince1970,
                    changed_at: Date(timeIntervalSince1970: changed_at).timeIntervalSince1970,
                    last_updated_by: String(describing: String(cString: last_updated_by!))
                ))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        sqlite3_close(db)
        
        return items
    }
    func deleteItem(id: String, named fileName: String = "Items") {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        let db = openDatabase(named: fileName)
        
        let deleteStatementString = "DELETE FROM Items WHERE Id = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Item deleted from the database.")
                
                let pragmaStatementString = "PRAGMA synchronous = FULL;"
                var pragmaStatement: OpaquePointer?
                
                if sqlite3_prepare_v2(db, pragmaStatementString, -1, &pragmaStatement, nil) == SQLITE_OK {
                    if sqlite3_step(pragmaStatement) == SQLITE_DONE {
                        print("Database synchronized with disk.")
                    } else {
                        print("Failed to synchronize the database with disk.")
                    }
                } else {
                    print("PRAGMA statement could not be prepared.")
                }
                
                sqlite3_finalize(pragmaStatement)
            } else {
                print("Failed to delete the item from the database.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        
        sqlite3_finalize(deleteStatement)
        sqlite3_close(db)
    }
    func insertItem(item: ToDoItem, named fileName: String){
        let db = openDatabase(named: fileName)
        
        let insertStatementString = "INSERT INTO Items (Id, Text, Importance, Deadline, Done, Created_At, Changed_At, Last_Updated_By) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db,insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_text(insertStatement, 1, (item.id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (item.text as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (item.importance.rawValue as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 4, item.deadline ?? 0)
            sqlite3_bind_int(insertStatement, 5, item.done ? 1 : 0)
            sqlite3_bind_double(insertStatement, 6, item.created_at)
            sqlite3_bind_double(insertStatement, 7, item.changed_at)
            sqlite3_bind_text(insertStatement, 8, (item.last_updated_by as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Succesfully inserted new item")
                let pragmaStatementString = "PRAGMA synchronous = FULL;"
                var pragmaStatement: OpaquePointer?
                
                if sqlite3_prepare_v2(db, pragmaStatementString, -1, &pragmaStatement, nil) == SQLITE_OK {
                    if sqlite3_step(pragmaStatement) == SQLITE_DONE {
                        print("Database synchronized with disk.")
                    } else {
                        print("Failed to synchronize the database with disk.")
                    }
                } else {
                    print("PRAGMA statement could not be prepared.")
                }
                
                sqlite3_finalize(pragmaStatement)
            }
            else{
                print("Failed to insert item to database")
            }
        }else{
            print("INSERT statement could not build")
        }
        sqlite3_finalize(insertStatement)
        sqlite3_close(db)
    }
    func updateItem(id: String, item: ToDoItem, named fileName: String) {
        let db = openDatabase(named: fileName)
        
        let updateStatementString = "UPDATE Items SET Text = ?, Importance = ?, Deadline = ?, Done = ?, Changed_At = ?, Last_Updated_By = ? WHERE Id = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (item.text as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (item.importance.rawValue as NSString).utf8String, -1, nil)
            sqlite3_bind_double(updateStatement, 3, item.deadline ?? 0)
            sqlite3_bind_int(updateStatement, 4, item.done ? 1 : 0)
            sqlite3_bind_double(updateStatement, 5, item.changed_at )
            sqlite3_bind_text(updateStatement, 6, (item.last_updated_by as NSString?)?.utf8String ?? nil, -1, nil)
            sqlite3_bind_text(updateStatement, 7, (id as NSString).utf8String, -1, nil)
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated item in the database.")
                
                let pragmaStatementString = "PRAGMA synchronous = FULL;"
                var pragmaStatement: OpaquePointer?
                
                if sqlite3_prepare_v2(db, pragmaStatementString, -1, &pragmaStatement, nil) == SQLITE_OK {
                    if sqlite3_step(pragmaStatement) == SQLITE_DONE {
                        print("Database synchronized with disk.")
                    } else {
                        print("Failed to synchronize the database with disk.")
                    }
                } else {
                    print("PRAGMA statement could not be prepared.")
                }
                
                sqlite3_finalize(pragmaStatement)
            } else {
                print("Failed to update the item in the database.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        
        sqlite3_finalize(updateStatement)
        sqlite3_close(db)
    }

    
}
