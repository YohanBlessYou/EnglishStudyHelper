import Foundation
import CoreData

class SentenceDataManager {
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sentence")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    func create(korean: String, english: String) {
        let sentence = Sentence(context: persistentContainer.viewContext)
        sentence.id = UUID().uuidString
        sentence.korean = korean
        sentence.english = english
        sentence.createdAt = Date()
        try? persistentContainer.viewContext.save()
    }
    
    func read() -> [Sentence] {
        let sentences = try? persistentContainer.viewContext.fetch(Sentence.fetchRequest())
        return sentences ?? []
    }
    
    func update(id: String, korean: String, english: String) {
        let fetchRequest = Sentence.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        guard let sentence = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            return
        }
        sentence.korean = korean
        sentence.english = english
        try? persistentContainer.viewContext.save()
    }
    
    func delete(id: String) {
        let fetchRequest = Sentence.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        guard let sentence = try? persistentContainer.viewContext.fetch(fetchRequest).first else {
            return
        }
        persistentContainer.viewContext.delete(sentence)
    }
}
