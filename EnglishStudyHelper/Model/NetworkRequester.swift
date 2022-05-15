import Foundation

enum NetworkRequester {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum HTTPError: Error {
        case URLSessionError(Error)
        case badStatusCode(Int)
        
        var description: String {
            switch self {
            case .URLSessionError(let error):
                return error.localizedDescription
            case .badStatusCode(let statusCode):
                return "badStatusCode : \(statusCode)"
            }
        }
    }
    
    static func request(
        url: URL,
        httpMethod: HTTPMethod,
        httpHeaders: [String: String],
        httpBody: Data
    ) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        httpHeaders.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = httpBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let _response = response as! HTTPURLResponse
        guard _response.statusCode == 200 else {
            throw HTTPError.badStatusCode(_response.statusCode)
        }
        return data
    }
}
