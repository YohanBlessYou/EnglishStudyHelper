import Foundation
import CloudKit

class CloudManager {
    enum CloudError: Error {
        case recordIsNil
    }
    
    static let shared = CloudManager()
    
    private let container = CKContainer(identifier: "iCloud.EnglishStudyHelper")
    private let recordType = "KoreanEnglishSentence"
    private let dispatchQueue = DispatchQueue(label: "CloudManager")
    
    func save(korean: String, english: String, completion: @escaping (Result<String, Error>) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let _self = self else { return }
            let result = _self._save(korean: korean, english: english)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func _save(korean: String, english: String) -> Result<String, Error> {
        let record = CKRecord(recordType: "KoreanEnglishSentence")
        record.setValuesForKeys([
            "id": UUID().uuidString,
            "createdAt": Date().timeIntervalSince1970,
            "korean": korean,
            "english": english
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
    
    func fetchAll(completion: @escaping (Result<[CKRecord], Error>) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let _self = self else { return }
            let result = _self._fetchAll()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func _fetchAll() -> Result<[CKRecord], Error> {
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
                self?.dispatchQueue.sync {
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
    
    func update(id: String, korean: String, english: String, completion: @escaping (Result<String, Error>) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let _self = self else { return }
            let result = _self._update(id: id, korean: korean, english: english)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func _update(id: String, korean: String, english: String) -> Result<String, Error> {
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
        
        //UPDATE
        guard let record = record else {
            return .failure(CloudError.recordIsNil)
        }
        
        let newRecord = CKRecord(recordType: recordType)
        newRecord.setValuesForKeys([
            "id": record.value(forKey: "id")!,
            "createdAt": record.value(forKey: "createdAt")!,
            "korean": record.value(forKey: "korean")!,
            "english": record.value(forKey: "english")!
        ])
        
        //SAVE
        group.enter()
        container.privateCloudDatabase.save(newRecord) { _, saveError in
            error = saveError
            group.leave()
        }
        group.wait()
        
        if let error = error {
            return .failure(error)
        } else {
            return .success("업데이트 성공")
        }
    }
    
    func delete(id: String, completion: @escaping (Result<String, Error>) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let _self = self else { return }
            let result = _self._delete(id: id)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func _delete(id: String) -> Result<String, Error> {
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
