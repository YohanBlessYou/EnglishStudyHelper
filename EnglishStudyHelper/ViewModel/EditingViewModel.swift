import Foundation

class EditingViewModel {
    var sentences: [Sentence] = SentenceManager.shared.all {
        didSet {
            onSentenceChanged?()
        }
    }
    
    var onSentenceChanged: (() -> ())?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(coreDataChanged),
            name: SentenceManager.shared.notificationName,
            object: nil
        )
    }
    
    @objc private func coreDataChanged() {
        sentences = SentenceManager.shared.all
    }
}
