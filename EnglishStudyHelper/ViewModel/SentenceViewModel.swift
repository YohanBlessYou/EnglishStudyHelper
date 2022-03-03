import Foundation

struct SentenceViewModel {
    private var sentenceActions: [(Sentence) -> ()] = []
    private var solutionHiddenActions: [(Bool) -> ()] = []
    private var currentSentence: Sentence? {
        didSet {
            guard let sentence = currentSentence else {
                return
            }
            sentenceActions.forEach {
                $0(sentence)
            }
        }
    }
    var solutionIsHidden: Bool = true {
        didSet {
            solutionHiddenActions.forEach {
                $0(solutionIsHidden)
            }
        }
    }
    private let sentences = SentenceDataManager.shared.read()

    mutating func addAction(sentenceAction: ((Sentence) -> ())?, solutionHiddenAction: ((Bool) -> ())?) {
        if let sentenceAction = sentenceAction {
            sentenceActions.append(sentenceAction)
        }
        
        if let solutionHiddenAction = solutionHiddenAction {
            solutionHiddenActions.append(solutionHiddenAction)
        }
    }
    
    mutating func toNext() {
        currentSentence = sentences.randomElement()
        solutionIsHidden = true
    }
}
