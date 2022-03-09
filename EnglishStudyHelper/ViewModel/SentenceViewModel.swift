import Foundation

class SentenceViewModel {
    var currentSentenceActions: [(Sentence) -> ()] = []
    var solutionIsHiddenActions: [(Bool) -> ()] = []
    var sentencesActions: [() -> ()] = []
    
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
    var solutionIsHidden: Bool = true {
        didSet {
            solutionIsHiddenActions.forEach {
                $0(solutionIsHidden)
            }
        }
    }
    var sentences = SentenceDataManager.shared.read() {
        didSet {
            sentencesActions.forEach {
                $0()
            }
        }
    }
    
    func toNext() {
        currentSentence = sentences.randomElement()
        solutionIsHidden = true
    }
    
    func deleteSentence(id: String) {
        SentenceDataManager.shared.delete(id: id)
        sentences = SentenceDataManager.shared.read()
    }
}
