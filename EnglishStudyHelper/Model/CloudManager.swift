import Foundation
import CloudKit

class CloudManager {
    static let shared = CloudManager()
    
    private let container = CKContainer(identifier: "iCloud.EnglishStudyHelper")
    private let recordType = "KoreanEnglishSentence"
    private let dispatchQueue = DispatchQueue(label: "CloudManager")
    
    func save(korean: String, english: String, completion: @escaping (Result<String, Error>) -> ()) {
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
            completion(.failure(error))
        } else {
            completion(.success("저장 성공"))
        }
    }
    
    func fetchAll(completion: @escaping (Result<[CKRecord], Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container.privateCloudDatabase
        
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
                completion(.success(records))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        operation.start()
    }
    
    func update(id: String, korean: String, english: String, completion: @escaping (Result<String, Error>) -> ()) {
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
            completion(.failure(error))
            return
        }
        
        //UPDATE
        guard let record = record else {
            print("record is nil")
            return
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
            completion(.failure(error))
        } else {
            completion(.success("업데이트 성공"))
        }
    }
    
    func delete(id: String, completion: @escaping (Result<String, Error>) -> ()) {
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
            completion(.failure(error))
            return
        }
        
        // DELETE
        guard let record = record else {
            print("record is nil")
            return
        }
        
        group.enter()
        container.privateCloudDatabase.delete(withRecordID: record.recordID) { _, deleteError in
            error = deleteError
            group.leave()
        }
        group.wait()
        
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success("삭제 성공"))
        }
    }
}
