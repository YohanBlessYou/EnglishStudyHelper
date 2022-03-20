import Foundation
import CoreData
import SwiftyDropbox

struct DropboxManager {
    struct SentenceForJSON: Codable {
        let createdAt: Double
        let korean: String
        let english: String
        let id: String
    }
    
    static let shared = DropboxManager()

    private init() {
        DropboxClientsManager.setupWithAppKey(UserInfo.Dropbox.appKey)
    }
    
    private let filePath = "/sentences.json"

    func upload(onComplete: (() -> ())?, onError: ((String) -> ())?) {
        guard let client = DropboxClientsManager.authorizedClient else {
            onError?("No client")
            return
        }
        let json = SentenceManager.shared.all.map {
            SentenceForJSON(createdAt: $0.createdAt, korean: $0.korean!, english: $0.english!, id: $0.id!)
        }
        let sentences = try! JSONEncoder().encode(json)
        
        client.files.upload(path: filePath, mode: .overwrite, input: sentences)
            .response { _, error in
                if let error = error {
                    onError?(error.description)
                }
                onComplete?()
            }
    }

    func download(onComplete: (() -> ())?, onError: ((String) -> ())?) {
        guard let client = DropboxClientsManager.authorizedClient else {
            onError?("No client")
            return
        }
        
        client.files.download(path: filePath, rev: nil)
            .response(queue: .main) { response, error in
                if let error = error {
                    onError?(error.description)
                    return
                }
                
                guard let data = response?.1 else {
                    onError?("데이터가 올바르지 않습니다")
                    return
                }

                let sentences = try! JSONDecoder().decode([SentenceForJSON].self, from: data)
                self.updateToCoreData(sentences: sentences)
                onComplete?()
            }
    }
    
    func authorize(target: UIViewController) {
        let scopes = [
            "account_info.read",
            "files.content.read",
            "files.content.write",
            "files.metadata.read",
        ]

        let scopeRequest = ScopeRequest(scopeType: .user, scopes: scopes, includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: target,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil)},
            scopeRequest: scopeRequest
        )
    }
    
    private func updateToCoreData(sentences: [SentenceForJSON]) {
        let outdatedSentences = SentenceManager.shared.all
        outdatedSentences.forEach { SentenceManager.shared.delete(id: $0.id!) }

        sentences.forEach {
            SentenceManager.shared.create(korean: $0.korean, english: $0.english)
        }
    }
}
