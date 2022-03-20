import Foundation

class StudyingViewModel {
    var selectedSentence: Sentence? {
        didSet {
            onSelectedSentenceChanged?(selectedSentence)
        }
    }
    
    var onSelectedSentenceChanged: ((Sentence?) -> ())?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(coreDataChanged),
            name: SentenceManager.shared.notificationName,
            object: nil
        )
    }
    
    @objc private func coreDataChanged() {
        if let id = selectedSentence?.id,
           let sentence = SentenceManager.shared.read(id: id) {
            reload(updated: sentence)
        } else {
            toNext()
        }
    }
    
    private func reload(updated sentence: Sentence) {
        onSelectedSentenceChanged?(sentence)
    }
    
    func toNext() {
        selectedSentence = SentenceManager.shared.all.randomElement()
    }
    
    func delete() {
        guard let id = selectedSentence?.id else { return }
        SentenceManager.shared.delete(id: id)
    }
}
