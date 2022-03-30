import Foundation
import CloudKit

class CloudManager {
    enum CloudError: Error {
        case recordIsNil
    }
    
    static let shared = CloudManager()
    
    private let container = CKContainer(identifier: "iCloud.EnglishStudyHelper")
    private let recordType = "KoreanEnglishSentence"
    private let mainDispatchQueue = DispatchQueue(label: "MainQueue")
    private let subDispatchQueue = DispatchQueue(label: "SubQueue")
    
    func save(completion: @escaping (Result<String, Error>) -> ()) {
        mainDispatchQueue.async {
            //1. CoreData 읽기
            var error: Error? = nil
            var records: [CKRecord] = []
            
            let result = self._fetch()
            
            switch result {
            case .success(let fetchRecords):
                records = fetchRecords
            case .failure(let fetchError):
                error = fetchError
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

            //2. iCloud 삭제
            let group = DispatchGroup()
            group.enter()
            records.forEach { record in
                DispatchQueue.global().async {
                    let result = self._delete(id: record["id"] as! String)
                    switch result {
                    case .success:
                        break
                    case .failure(let deleteError):
                        error = deleteError
                    }
                    group.leave()
                }
                group.enter()
            }
            group.leave()
            group.wait()
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            //2. iCloud 저장
            group.enter()
            SentenceManager.shared.all.forEach { sentence in
                DispatchQueue.global().async {
                    let result = self._save(sentence: sentence)
                    switch result {
                    case .success:
                        break
                    case .failure(let saveError):
                        error = saveError
                    }
                    group.leave()
                }
                group.enter()
            }
            group.leave()
            group.wait()
            
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success("업로드 성공"))
                }
            }
        }
    }
    
    func fetch(completion: @escaping (Result<String, Error>) -> ()) {
        mainDispatchQueue.async {
            //1. iCloud 불러오기
            var error: Error? = nil
            var records: [CKRecord] = []
            
            let result = self._fetch()
            
            switch result {
            case .success(let fetchRecords):
                records = fetchRecords
            case .failure(let fetchError):
                error = fetchError
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            //2. CoreData 삭제
            SentenceManager.shared.deleteAll()
            
            //3. CoreData 저장
            records.forEach {
                let id = $0["id"] as! String
                let createdAt = $0["createdAt"] as! Double
                let korean = $0["korean"] as! String
                let english = $0["english"] as! String
                SentenceManager.shared.create(id: id, createdAt: createdAt, korean: korean, english: english)
            }
            
            DispatchQueue.main.async {
                completion(.success("다운로드 성공"))
            }
        }
    }
    
    private func _save(sentence: Sentence) -> Result<String, Error> {
        let record = CKRecord(recordType: "KoreanEnglishSentence")
        record.setValuesForKeys([
            "id": sentence.id!,
            "createdAt": sentence.createdAt,
            "korean": sentence.korean!,
            "english": sentence.english!
        ])
        
        let group = DispatchGroup()
        var error: Error? = nil
        
        //SAVE
        group.enter()
        container.privateCloudDatabase.save(record) { _, saveError in
            error = saveError
            group.leave()
        }
        group.wait()
        
        if let error = error {
            return .failure(error)
        } else {
            return .success("저장 성공")
        }
    }
    
    private func _fetch() -> Result<[CKRecord], Error> {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container.privateCloudDatabase
        
        let group = DispatchGroup()
        var error: Error? = nil
        
        var records: [CKRecord] = []
        operation.recordMatchedBlock = { [weak self] recordID, result in
            switch result {
            case .success(let record):
                self?.subDispatchQueue.sync {
                    records.append(record)
                }
            case .failure(let error):
                print(error)
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                break
            case .failure(let operationError):
                error = operationError
            }
            group.leave()
        }
        group.enter()
        operation.start()
        group.wait()
        
        if let error = error {
            return .failure(error)
        } else {
            return .success(records)
        }
    }

    private func _delete(id: String) -> Result<String, Error> {
        // READ
        let predicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container.privateCloudDatabase
        
        let group = DispatchGroup()
        var record: CKRecord! = nil
        var error: Error? = nil
        
        operation.recordMatchedBlock = { _, result in
            switch result {
            case .success(let operationRecord):
                record = operationRecord
            case .failure(let operationError):
                error = operationError
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                break
            case .failure(let operationError):
                error = operationError
            }
            group.leave()
        }
        group.enter()
        operation.start()
        group.wait()
        
        if let error = error {
            return .failure(error)
        }
        
        // DELETE
        guard let record = record else {
            return .failure(CloudError.recordIsNil)
        }
        
        group.enter()
        container.privateCloudDatabase.delete(withRecordID: record.recordID) { _, deleteError in
            error = deleteError
            group.leave()
        }
        group.wait()
        
        if let error = error {
            return .failure(error)
        } else {
            return .success("삭제 성공")
        }
    }
}
