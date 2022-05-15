import Foundation

class PapagoManager {
    static let shared = PapagoManager()
    
    private let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt")!
    private let httpHeaders = [
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Naver-Client-Id": UserInfo.Papago.clientID,
        "X-Naver-Client-Secret": UserInfo.Papago.secret
    ]
    private let httpBodyPrefix = "source=ko&target=en&text="
    
    private init() { }
    
    func translate(korean: String) async throws -> Data {
        return try await NetworkRequester.request(
            url: url,
            httpMethod: .POST,
            httpHeaders: httpHeaders,
            httpBody: (httpBodyPrefix+korean).data(using: .utf8)!
        )
    }
}

extension PapagoManager {
    struct Response: Codable {
        struct Message: Codable {
            struct Result: Codable {
                var srcLangType: String?
                var tarLangType: String?
                var translatedText: String?
                var engineType: String?
                var pivot: String?
                var dict: String?
                
            }
            var result: Result?
            var type: String?
            var service: String?
            var version: String?
        }
        var message: Message
    }
}
