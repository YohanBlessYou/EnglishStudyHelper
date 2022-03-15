import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

class GoogleDriveManager {
    static let shared = GoogleDriveManager()
    
    var isLoggedIn: Bool {
        return GIDSignIn.sharedInstance.currentUser != nil
    }
    private let service = GTLRDriveService()
    private let targetFile: GTLRDrive_File = {
        let file = GTLRDrive_File()
        file.name = "EnglishStudyHelper.json"
        return file
    }()

    private init() { }
}

//MARK: - Authentication
extension GoogleDriveManager {
    func toggleAuthentication(target: UIViewController?, onLoggedIn: (() -> ())?, onLoggedOut: (() -> ())?, onError: (() -> ())?) {
        if isLoggedIn {
            logout(onComplete: onLoggedOut)
        } else {
            guard let target = target else { return }
            login(target: target, onComplete: onLoggedIn, onError: onError)
        }
    }

    func login(target: UIViewController, onComplete: (() -> ())?, onError: (() -> ())?) {
        let signInConfig = GIDConfiguration(clientID: UserInfo.GoogleDrive.clientId)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: target) { user, error in
            guard error == nil else {
                onError?()
                return
            }
            self.service.authorizer = user?.authentication.fetcherAuthorizer()
            self.addDriveScope(target: target, onComplete: onComplete, onError: onError)
        }
    }
    
    func logout(onComplete: (() -> ())?) {
        GIDSignIn.sharedInstance.signOut()
        onComplete?()
    }
    
    private func addDriveScope(target: UIViewController, onComplete: (() -> ())?, onError: (() -> ())?) {
        let driveScope = "https://www.googleapis.com/auth/drive"
        GIDSignIn.sharedInstance.addScopes([driveScope], presenting: target) { user, error in
            onComplete?()
        }
    }
}

//MARK: - Data IO
extension GoogleDriveManager {
    struct SentenceForJSON: Codable {
        let createdAt: Double
        let korean: String
        let english: String
        let id: String
    }
    
    func upload(onComplete: (() -> ())?, onError: (() -> ())?) {
        let currentSentences = SentenceViewModel.shared.sentences.map {
            SentenceForJSON(createdAt: $0.createdAt, korean: $0.korean!, english: $0.english!, id: $0.id!)
        }
        let json = try! JSONEncoder().encode(currentSentences)

        let params = GTLRUploadParameters(data: json, mimeType: "application/json")
        params.shouldUploadWithSingleRequest = true
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: targetFile, uploadParameters: params)
        query.fields = "id"
        
        service.executeQuery(query, completionHandler: { (ticket, file, error) in
            guard error == nil else {
                onError?()
                return
            }
            onComplete?()
        })
    }
    
    func download(onComplete: (() -> ())?, onError: (() -> ())?) {
        guard let fileID = targetFile.identifier else {
            onError?()
            return
        }
        
        self.service.executeQuery(GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)) { (ticket, file, error) in
            guard let data = (file as? GTLRDataObject)?.data else {
                onError?()
                return
            }
            let sentence = try! JSONDecoder().decode(SentenceForJSON.self, from: data)
            onComplete?()
        }
    }
}
