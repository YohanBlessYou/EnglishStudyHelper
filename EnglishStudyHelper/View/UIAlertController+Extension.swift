import UIKit

extension UIAlertController {
    enum Basic {
        static func warning(target: UIViewController, message: String) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(cancelAction)
            target.present(alert, animated: true)
        }
    }
}
