import Foundation

class SentenceViewModel {
    static let shared = SentenceViewModel()
    
    weak var selectedSentence: Sentence?
    lazy var sentences = sentenceDataManager.read()
    private let sentenceDataManager = SentenceDataManager()
    private var onNext: [(Sentence) -> ()] = []
    private var onCreate: [() -> ()] = []
    private var onUpdate: [(String, String, String) -> ()] = []
    private var onDelete: [() -> ()] = []
    
    private init() { }
    
    func registerHandler(
        onNext: ((Sentence) -> ())? = nil,
        onCreate: (() -> ())? = nil,
        onUpdate: ((String, String, String) -> ())? = nil,
        onDelete: (() -> ())? = nil
    ) {
        if let onNext = onNext {
            self.onNext.append(onNext)
        }
        if let onCreate = onCreate {
            self.onCreate.append(onCreate)
        }
        if let onUpdate = onUpdate {
            self.onUpdate.append(onUpdate)
        }
        if let onDelete = onDelete {
            self.onDelete.append(onDelete)
        }
    }
    
    func find(id: String) -> Sentence? {
        sentences.filter {
            $0.id == id
        }.first
    }
    
    func toNext() {
        guard let newSentence = sentences.randomElement() else { return }
        selectedSentence = newSentence
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
