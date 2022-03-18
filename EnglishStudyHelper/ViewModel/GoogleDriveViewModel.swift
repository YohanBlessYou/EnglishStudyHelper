import Foundation

class GoogleDriveViewModel {
    static let shared = GoogleDriveViewModel()

    private let googleDriveManager = GoogleDriveManager()
    private var onUpload: [() -> ()] = []
    private var onDownload: [() -> ()] = []
    private var onError: [() -> ()] = []
    
    private init() { }
    
    func registerHandler(
        onUpload: (() -> ())? = nil,
        onDownload: (() -> ())? = nil,
        onError: (() -> ())? = nil
    ) {
        if let onUpload = onUpload {
            self.onUpload.append(onUpload)
        }
        if let onDownload = onDownload {
            self.onDownload.append(onDownload)
        }
        if let onError = onError {
            self.onError.append(onError)
        }
    }
    
    func upload(target: UIViewController) {
        googleDriveManager.login(target: target, onComplete: { [weak self] in
            self?.googleDriveManager.upload(onComplete: {
                self?.onUpload.forEach { $0() }
            }, onError: {
                self?.onError.forEach { $0() }
            })
        }, onError: { [weak self] in
            self?.onError.forEach { $0() }
        })
    }
    
    func download(target: UIViewController) {
        googleDriveManager.login(target: target, onComplete: { [weak self] in
            self?.googleDriveManager.download(onComplete: {
                self?.onDownload.forEach { $0() }
            }, onError: {
                self?.onError.forEach { $0() }
            })
        }, onError: { [weak self] in
            self?.onError.forEach { $0() }
        })
    }
}
