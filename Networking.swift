import Foundation
import UIKit

struct ToDoResponse: Codable {
    let status: String
    let list: [ResponseItem]
    let revision: Int
}
struct ToDoPostRequest: Codable {
    let status: String
    let element: ResponseItem
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
    func getToDoItems(completion: @escaping (Result<[ResponseItem], Error>) -> Void)
    
}

class DefaultNetworkingService: NetworkingService {
    private let baseURL = URL(string: "https://beta.mrdekk.ru/todobackend")!
    private let session = URLSession.shared
    private let token = "whoremastery"
    private var isDirty = false

func getToDoItems(completion: @escaping (Result<[ResponseItem], Error>) -> Void)
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
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//            //    print(json)
//            }

            do {
                let decoder = JSONDecoder()
                let todoResponse = try decoder.decode(ToDoResponse.self, from: data)
                
                let todos: [ResponseItem] = todoResponse.list.map { responseItem in
                    let id = responseItem.id
                    let deadline = responseItem.deadline
                    let createdDate = responseItem.created_at
                    let changedDate = responseItem.changed_at
                    let deviceID = UIDevice.current.identifierForVendor?.uuidString

                    return ResponseItem(
                                    id: id,
                                    text: responseItem.text,
                                    importance: responseItem.importance,
                                    deadline: deadline,
                                    done: responseItem.done,
                                    color: responseItem.color,
                                    created_at: createdDate,
                                    changed_at: changedDate,
                                    last_updated_by: deviceID!
                    )
                }
                
               // print(todos)
                completion(.success(todos))
                
            } catch {
                completion(.failure(error))
            }
        }
    }

    task.resume()
}
        func updateList(list: [ToDoItem], revision: Int32, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
            let url = baseURL.appendingPathComponent("/list")
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")

            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(list)
                request.httpBody = data

                let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    if let data = data {
                        
                        do {
                            let decoder = JSONDecoder()
                            let updatedList = try decoder.decode([ToDoItem].self, from: data)
                            print(updatedList)
                            completion(.success(updatedList))
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
    
    func addTodoItem(_ todoItem: ResponseItem, revision: Int, completion: @escaping (Result<ResponseItem, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/list")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let postRequest = ToDoPostRequest(status: "ok", element: todoItem)
                   print("postRequest: \(postRequest)")
            let data = try encoder.encode(postRequest)
            request.httpBody = data
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
                        let newItem = try decoder.decode(ToDoPostRequest.self, from: data)
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
    func getTodoItem(withId id: String, completion: @escaping (Result<ResponseItem, Error>) -> Void) {
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
                let response = try decoder.decode(ToDoPostRequest.self, from: data)
                completion(.success(response.element))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func updateTodoItem(withId id: String, item: ResponseItem, completion: @escaping (Result<ResponseItem, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/list/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let requestBody = ToDoPostRequest(status: "ok", element: item)
            let data = try encoder.encode(requestBody)
            request.httpBody = data
            
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
                    let updatedItem = try decoder.decode(ToDoPostRequest.self, from: data)
                    completion(.success(updatedItem.element))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
            
        } catch {
            completion(.failure(error))
        }
    }


    
}
