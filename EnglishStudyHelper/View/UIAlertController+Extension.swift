import UIKit

extension UIViewController {
    func presentBasicAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}
