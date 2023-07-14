import Foundation
import UIKit

struct ToDoResponse: Codable {
    let status: String
    let list: [ToDoItem]
//    let revision: Int
}
struct ToDoPostRequest: Codable {
    let status: String
    let element: ToDoItem
}
struct ToDoPostAnswer: Codable{
    let element: ToDoItem
    let revision: Int
}
struct ToDoPatchRequest: Codable {
    let status: String
    let list: [ToDoItem]
    let revision: Int
}
struct ResponseItem: Codable {
    let id: String
    let text: String
    let importance: priority
    let deadline: Double?
    let done: Bool
    let color: String?
    let created_at: Double
    let changed_at: Double
    let last_updated_by: String
}
protocol NetworkingService {
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    
}

class DefaultNetworkingService: NetworkingService {
    public var currentRevision : Int = 0;
    private let baseURL = URL(string: "https://beta.mrdekk.ru/todobackend")!
    private let session = URLSession.shared
    private let token = "whoremastery"
    private var isDirty = false
//MARK: -- Function to get list of items
func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    {
    let url = baseURL.appendingPathComponent("/list")
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        if let data = data {
            do {
                let decoder = JSONDecoder()
                let todoResponse = try decoder.decode(ToDoPatchRequest.self, from: data)
                
                self.currentRevision = todoResponse.revision
                
                let todos: [ToDoItem] = todoResponse.list.map { serverItem in
                    let id = serverItem.id
                    let deadline = serverItem.deadline
                    let createdDate = serverItem.created_at
                    let changedDate = serverItem.changed_at
                    let deviceID = UIDevice.current.identifierForVendor?.uuidString
                    return ToDoItem(id: id, text: serverItem.text, importance: serverItem.importance, deadline: deadline, done: serverItem.done, created_at: createdDate, changed_at: changedDate, last_updated_by: deviceID ?? "Beka's iPhone")
         
                }
                completion(.success(todos))
                
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}
    //MARK: -- Function to update list
        func updateList(list: [ToDoItem], completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
            let url = baseURL.appendingPathComponent("/list")
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("\(self.currentRevision)", forHTTPHeaderField: "X-Last-Known-Revision")

            do {
                let encoder = JSONEncoder()
                let postRequest = ToDoResponse(status: "ok", list: list)
                let data = try encoder.encode(postRequest)
                request.httpBody = data

                let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    if let data = data {
                        
                        do {
                            let decoder = JSONDecoder()
                            let updatedList = try decoder.decode(ToDoPatchRequest.self, from: data)
                            self.currentRevision = updatedList.revision
                            completion(.success(updatedList.list))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }

                task.resume()
            } catch {
                completion(.failure(error))
            }
        }
    // MARK: -- Function that adds new TodoItem
    func addTodoItem(_ todoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/list")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("\(self.currentRevision)", forHTTPHeaderField: "X-Last-Known-Revision")
        print("cur Rev: \(self.currentRevision)")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let postRequest = ToDoPostRequest(status: "ok", element: todoItem)
            let data = try encoder.encode(postRequest)
            request.httpBody = data
            print(postRequest)
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if let error = NetworkError(statusCode: httpResponse.statusCode) {
                        completion(.failure(error))
                        return
                    }
                }

                if let data = data {
                    
                    do {
                        let decoder = JSONDecoder()
                        let newItem = try decoder.decode(ToDoPostAnswer.self, from: data)
                        self.currentRevision = newItem.revision
                        completion(.success(newItem.element))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()

        } catch {
            completion(.failure(error))
        }
    }
    //MARK: -- Function to update certain item
    
    func updateTodoItem(withId id: String, item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/list/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(currentRevision)", forHTTPHeaderField: "X-Last-Known-Revision")
        do {
            let encoder = JSONEncoder()
            let requestBody = ToDoPostRequest(status: "ok", element: item)
            let data = try encoder.encode(requestBody)
            request.httpBody = data
            print(requestBody)
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if let networkError = NetworkError(statusCode: httpResponse.statusCode) {
                        completion(.failure(networkError))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.unknown))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let updatedItem = try decoder.decode(ToDoPostAnswer.self, from: data)
                    completion(.success(updatedItem.element))
                    self.currentRevision = updatedItem.revision
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
    //MARK: -- Function to get item by id
    func getTodoItem(withId id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/list/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ToDoPostAnswer.self, from: data)
                self.currentRevision = response.revision
                completion(.success(response.element))
                
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    // MARK: -- function to delete item by id
    func deleteTodoItem(withID id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void){
        let url = baseURL.appendingPathComponent("/list/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(currentRevision)", forHTTPHeaderField: "X-Last-Known-Revision")
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(.failure(error))
            }
            
            guard let data = data else{
                completion(.failure(NetworkError.unknown))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ToDoPostAnswer.self, from: data)
                self.currentRevision = response.revision
                completion(.success(response.element))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
}
