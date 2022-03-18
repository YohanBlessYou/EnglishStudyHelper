import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

class GoogleDriveManager {
    private let service = GTLRDriveService()
    private let fileName = "EnglishStudyHelper.json"
}

//MARK: - Authentication
extension GoogleDriveManager {
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
    
    private func addDriveScope(target: UIViewController, onComplete: (() -> ())?,onError: (() -> ())?) {
        let driveScope = "https://www.googleapis.com/auth/drive"
        GIDSignIn.sharedInstance.addScopes([driveScope], presenting: target) { user, error in
            onComplete?()
        }
    }
    
    func logout(onLoggedOut: (() -> ())?) {
        GIDSignIn.sharedInstance.signOut()
        onLoggedOut?()
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
        
        executeFindQuery(onComplete: { file in
            self.executeUpdateQuery(data: json, fileId: file.identifier!, onComplete: onComplete, onError: onError)
        }, onError: {
            self.executeUploadQuery(data: json, onComplete: onComplete, onError: onError)
        })
    }
    
    func download(onComplete: (() -> ())?, onError: (() -> ())?) {
        executeFindQuery(onComplete: { file in
            self.executeDownloadQuery(file: file, onComplete: onComplete, onError: onError)
        }, onError: onError)
    }
    
    private func executeUploadQuery(data: Data, onComplete: (() -> ())?, onError: (() -> ())?) {
        let params = GTLRUploadParameters(data: data, mimeType: "application/json")
        params.shouldUploadWithSingleRequest = true
        
        let file = GTLRDrive_File()
        file.name = fileName
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: params)
        query.fields = "id"
        
        service.executeQuery(query, completionHandler: { (ticket, file, error) in
            guard error == nil else {
                onError?()
                return
            }
            onComplete?()
        })
    }
    
    private func executeUpdateQuery(data: Data, fileId: String, onComplete: (() -> ())?, onError: (() -> ())?) {
        let params = GTLRUploadParameters(data: data, mimeType: "application/json")
        
        let file = GTLRDrive_File()
        file.name = fileName
        let query = GTLRDriveQuery_FilesUpdate.query(withObject: file, fileId: fileId, uploadParameters: params)
        query.fields = "id"
        
        service.executeQuery(query, completionHandler: { (ticket, file, error) in
            guard error == nil else {
                onError?()
                return
            }
            onComplete?()
        })
    }
    
    private func executeFindQuery(onComplete: ((GTLRDrive_File) -> ())?, onError: (() -> ())?) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 1
        query.q = "name contains '\(String(describing: fileName))'"
        
        service.executeQuery(query) { (ticket, results, error) in
            if let error = error {
                onError?()
                return
            }
            
            guard let file = (results as? GTLRDrive_FileList)?.files?.first else {
                onError?()
                return
            }
            
            onComplete?(file)
        }
    }
    
    private func executeDownloadQuery(file: GTLRDrive_File, onComplete: (() -> ())?, onError: (() -> ())?) {
        guard let fileID = file.identifier else {
            onError?()
            return
        }
        
        service.executeQuery(GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)) { (ticket, file, error) in
            guard let data = (file as? GTLRDataObject)?.data else {
                onError?()
                return
            }
            let sentences = try! JSONDecoder().decode([SentenceForJSON].self, from: data)
            self.updateCoreData(newSentences: sentences)
            onComplete?()
        }
    }
    
    private func updateCoreData(newSentences: [SentenceForJSON]) {
        let coreDataSentences = SentenceViewModel.shared.sentences
        coreDataSentences.forEach { SentenceViewModel.shared.delete(id: $0.id!) }
        
        newSentences.forEach {
            SentenceViewModel.shared.create(korean: $0.korean, english: $0.english)
        }
    }
}
