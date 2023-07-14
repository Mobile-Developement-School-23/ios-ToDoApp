enum NetworkError: Error {
    case badRequest
    case unauthorized
    case notFound
    case serverError
    case unknown

    init?(statusCode: Int) {
        switch statusCode {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 404: self = .notFound
        case 500...599: self = .serverError
        default: return nil
        }
    }
}
