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
        httpBody: Data,
        completion: @escaping (Result<Data, HTTPError>) -> ()
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        httpHeaders.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.URLSessionError(error)))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                      return
                  }
            
            
            guard response.statusCode == 200 else {
                completion(.failure(.badStatusCode(response.statusCode)))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
