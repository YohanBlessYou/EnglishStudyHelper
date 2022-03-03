import Foundation

struct SentenceViewModel {
    private var actions: [(Sentence) -> ()] = []
    private var currentSentence: Sentence? {
        didSet {
            guard let sentence = currentSentence else {
                return
            }
            actions.forEach {
                $0(sentence)
            }
        }
    }
    private let sentences = SentenceDataManager.shared.read()

    mutating func addAction(_ action: @escaping (Sentence) -> ()) {
        actions.append(action)
    }
    
    mutating func toNext() {
        currentSentence = sentences.randomElement()
    }
}
