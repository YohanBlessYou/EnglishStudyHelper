import Foundation

struct SentenceViewModel {
    private lazy var currentID: UUID? = randomID()
    private let sentences = SentenceDataManager.shared.read()
    
    private func randomID() -> UUID? {
        let ids = sentences.compactMap { $0.id }
        return ids.randomElement()
    }
}
