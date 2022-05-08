import Foundation
import CoreData

class SentenceManager {
    static let shared = SentenceManager()
    
    private init() {}
    
    let notificationName = Notification.Name("data changed")

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sentence")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
}

//MARK: - CRUD
extension SentenceManager {
    var all: [Sentence] {
        let request = Sentence.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let sentences = try? persistentContainer.viewContext.fetch(request)
        return sentences ?? []
    }
    
    func read(id: String) -> Sentence? {
        let fetchRequest = Sentence.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return try? persistentContainer.viewContext.fetch(fetchRequest).first
    }
    
    func create(
        id: String = UUID().uuidString,
        createdAt: Double = Date().timeIntervalSince1970,
        korean: String,
        english: String
    ) {
        let sentence = Sentence(context: persistentContainer.viewContext)
        sentence.id = id
        sentence.korean = korean
        sentence.english = english
        sentence.createdAt = createdAt
        try? persistentContainer.viewContext.save()
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func update(id: String, korean: String, english: String) {
        guard let sentence = read(id: id) else { return }
        sentence.korean = korean
        sentence.english = english
        try? persistentContainer.viewContext.save()
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func delete(id: String) {
        let fetchRequest = Sentence.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        guard let sentence = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            return
        }
        persistentContainer.viewContext.delete(sentence)
        
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func deleteAll() {
        all.forEach {
            delete(id: $0.id!)
        }
    }
}
