import Foundation

struct PapagoManager {
    private let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt")!
    private let headers = [
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Naver-Client-Id": UserInfo.Papago.clientID,
        "X-Naver-Client-Secret": UserInfo.Papago.secret
    ]
    private let bodyPrefix = "source=ko&target=en&text="
    
    func translate(korean: String, completion: @escaping (Data) -> ()) {
        NetworkRequester.request(
            url: url,
            httpMethod: .POST,
            httpHeaders: headers,
            httpBody: (bodyPrefix+korean).data(using: .utf8)!,
            completion: completion
        )
    }
}
