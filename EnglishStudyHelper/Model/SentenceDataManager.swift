import Foundation
import CoreData

class SentenceDataManager {
    static let shared = SentenceDataManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sentence")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private init() { }
    
    func create(korean: String, english: String) {
        let sentence = Sentence(context: persistentContainer.viewContext)
        sentence.id = UUID()
        sentence.korean = korean
        sentence.english = english
        try? persistentContainer.viewContext.save()
    }
    
    func read() -> [Sentence] {
        let sentences = try? persistentContainer.viewContext.fetch(Sentence.fetchRequest())
        return sentences ?? []
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
}
