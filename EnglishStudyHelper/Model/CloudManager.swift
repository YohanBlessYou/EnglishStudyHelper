import Foundation
import CloudKit

class CloudManager {
    static let shared = CloudManager()
    
    private let container = CKContainer(identifier: "iCloud.EnglishStudyHelper")
    private let recordType = "KoreanEnglishSentence"
    
    func upload() async throws {
        try await deleteAll()
  
        for sentence in SentenceManager.shared.all {
            try await save(sentence)
        }
    }
    
    func download() async throws {
        let records = try await fetch()

        SentenceManager.shared.deleteAll()
        
        records.forEach {
            let id = $0["id"] as! String
            let createdAt = $0["createdAt"] as! Double
            let korean = $0["korean"] as! String
            let english = $0["english"] as! String
            SentenceManager.shared.create(id: id, createdAt: createdAt, korean: korean, english: english)
        }
    }
    
    private func fetch() async throws -> [CKRecord] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container.privateCloudDatabase
        let result = try await container.privateCloudDatabase.records(matching: query)
        return result.matchResults.compactMap { try? $0.1.get() }
    }
    
    private func save(_ sentence: Sentence) async throws {
        let record = CKRecord(recordType: recordType)
        record.setValuesForKeys([
            "id": sentence.id!,
            "createdAt": sentence.createdAt,
            "korean": sentence.korean!,
            "english": sentence.english!
        ])

        try await container.privateCloudDatabase.save(record)
    }
    
    private func deleteAll() async throws {
        let records = try await fetch()
        
        for record in records {
            try await container.privateCloudDatabase.deleteRecord(withID: record.recordID)
        }
    }
}
