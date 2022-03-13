import Foundation

class SentenceViewModel {
    static let shared = SentenceViewModel()
    
    var onNext: [(Sentence?) -> ()] = []
    var onCreate: [() -> ()] = []
    var onUpdate: [(String, String, String) -> ()] = []
    var onDelete: [() -> ()] = []
    lazy var sentences = sentenceDataManager.read()
    weak var currentSentence: Sentence?
    
    private let sentenceDataManager = SentenceDataManager()
    
    private init() { }
    
    func getSentence(fromId id: String) -> Sentence? {
        sentences.filter {
            $0.id == id
        }.first
    }
    
    func toNext() {
        let newSentence = sentences.randomElement()
        currentSentence = newSentence
        onNext.forEach { $0(newSentence) }
    }
    
    func create(korean: String, english: String) {
        sentenceDataManager.create(korean: korean, english: english)
        sentences = sentenceDataManager.read()
        onCreate.forEach { $0() }
    }
    
    func update(id: String, korean: String, english: String) {
        sentenceDataManager.update(id: id, korean: korean, english: english)
        onUpdate.forEach { $0(id, korean, english) }
    }
    
    func delete(id: String) {
        sentenceDataManager.delete(id: id)
        sentences = sentenceDataManager.read()
        onDelete.forEach { $0() }
    }
}
