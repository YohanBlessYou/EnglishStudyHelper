import Foundation

class SentenceViewModel {
    static let shared = SentenceViewModel()
    
    var currentSentenceActions: [(Sentence) -> ()] = []
    var solutionIsHiddenActions: [(Bool) -> ()] = []
    var sentencesActions: [() -> ()] = []
    
    var solutionIsHidden: Bool = true {
        didSet {
            solutionIsHiddenActions.forEach {
                $0(solutionIsHidden)
            }
        }
    }
    lazy var sentences = sentenceDataManager.read() {
        didSet {
            sentencesActions.forEach {
                $0()
            }
        }
    }
    
    private let sentenceDataManager = SentenceDataManager()
    
    private var currentSentence: Sentence? {
        didSet {
            guard let sentence = currentSentence else {
                return
            }
            currentSentenceActions.forEach {
                $0(sentence)
            }
        }
    }
    
    private init() { }
    
    func sentence(fromId id: String) -> Sentence? {
        sentences.filter {
            $0.id == id
        }.first
    }
    
    func toNext() {
        currentSentence = sentences.randomElement()
        solutionIsHidden = true
    }
    
    func onCreate(korean: String, english: String) {
        sentenceDataManager.create(korean: korean, english: english)
        sentences = sentenceDataManager.read()
    }
    
    func onUpdate(id: String, korean: String, english: String) {
        sentenceDataManager.update(id: id, korean: korean, english: english)
        sentences = sentenceDataManager.read()
    }
    
    func onDelete(id: String) {
        sentenceDataManager.delete(id: id)
        sentences = sentenceDataManager.read()
    }
}
