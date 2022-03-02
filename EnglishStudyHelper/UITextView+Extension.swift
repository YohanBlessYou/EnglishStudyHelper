import UIKit

extension UITextView {
    var isOnlyKorean: Bool {
        let notKoreanCharacters = self.text.filter({
            $0 < "ㄱ" || $0 > "힣"
        })
        return notKoreanCharacters.isEmpty
    }
    var isOnlyEnglish: Bool {
        let notEnglishCharacters = self.text.filter({
            $0 < "A" || $0 > "z"
        })
        return notEnglishCharacters.isEmpty
    }
}
