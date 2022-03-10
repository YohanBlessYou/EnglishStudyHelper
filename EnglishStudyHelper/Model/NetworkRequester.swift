import Foundation

enum NetworkRequester {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    static func request(
        url: URL,
        httpMethod: HTTPMethod,
        httpHeaders: [String: String],
        httpBody: Data,
        completion: @escaping (Data) -> ()
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        httpHeaders.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }

            guard let data = data,
                let response = response as? HTTPURLResponse else {
                return
            }

            print(response.statusCode)
            print(String(data: data, encoding: .utf8))
            completion(data)
        }.resume()
    }
}
