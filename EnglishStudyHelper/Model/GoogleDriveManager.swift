import Foundation
import GoogleSignIn

class GoogleDriveManager {
    struct SentenceForJSON: Codable {
        let createdAt: Double
        let korean: String
        let english: String
        let id: String
    }
    
    static let shared = GoogleDriveManager()
    
    var isLoggedIn: Bool {
        return GIDSignIn.sharedInstance.currentUser != nil
    }
    private let url = URL(string: "https://www.googleapis.com/upload/drive/v3/files?uploadType=media")!
    private let signInConfig = GIDConfiguration.init(clientID: UserInfo.GoogleDrive.clientId)
    
    private init() { }
    
    func upload(completion: (Result<Data,NetworkRequester.HTTPError>) -> ()) {
        //1. JSON 파일로 변환
        let jsonSentences = SentenceViewModel.shared.sentences.map {
            SentenceForJSON(createdAt: $0.createdAt, korean: $0.korean!, english: $0.english!, id: $0.id!)
        }
        let json = try! JSONEncoder().encode(jsonSentences)
        
        //2. 네트워크 요청
    }
    
    func fetch() {
        
    }
    
    func toggleAuthentication(target: UIViewController?, onLoggedIn: (() -> ())?, onLoggedOut: (() -> ())?, onError: (() -> ())?) {
        if isLoggedIn {
            logout(onComplete: onLoggedOut)
        } else {
            guard let target = target else { return }
            login(target: target, onComplete: onLoggedIn, onError: onError)
        }
    }

    func login(target: UIViewController, onComplete: (() -> ())?, onError: (() -> ())?) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: target) { user, error in
            guard error == nil else {
                onError?()
                return
            }
            
            onComplete?()
        }
    }
    
    func logout(onComplete: (() -> ())?) {
        GIDSignIn.sharedInstance.signOut()
        onComplete?()
    }
}
