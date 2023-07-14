import Foundation
extension URLSession {
    
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var task: URLSessionTask?
        return try await withTaskCancellationHandler(operation: {
            return try await withCheckedThrowingContinuation { continuation in
                task = dataTask(with: urlRequest) { (data, response, error) in
                    if let e = error {
                        continuation.resume(throwing: e)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        continuation.resume(throwing: URLError(.unknown))
                    }
                }
                task?.resume()
            
            }
        }, onCancel: {[weak task] in
            task?.cancel()
        })
        
    }
}
