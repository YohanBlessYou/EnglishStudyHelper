import UIKit
import SwiftyDropbox

class MainViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startButton: ButtonStyleView = {
        let icon = UIImage(named: "play")!
        let button = ButtonStyleView(image: icon, title: "시작하기")
        button.addTarget { [weak self] in
            self?.navigationController?.pushViewController(StudyingViewController(), animated: true)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var editingButton: ButtonStyleView = {
        let icon = UIImage(named: "edit")!
        let button = ButtonStyleView(image: icon, title: "편집하기")
        button.addTarget { [weak self] in
            self?.navigationController?.pushViewController(EditingViewController(), animated: true)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addButton: ButtonStyleView = {
        let icon = UIImage(named: "add")!
        let button = ButtonStyleView(image: icon, title: "문장추가")
        button.addTarget { [weak self] in
            self?.present(AddingViewController(), animated: true)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dropboxButton: ButtonStyleView = {
        let icon = UIImage(named: "dropbox")!
        let button = ButtonStyleView(image: icon, title: "Dropbox")
        button.addTarget { [weak self] in
            guard let target = self else { return }
            if DropboxClientsManager.authorizedClient == nil {
                DropboxManager.shared.authorize(target: target)
                return
            }
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let uploadAction = UIAlertAction(title: "내보내기", style: .default) { [weak self] _ in
                self?.upload()
            }
            let downloadAction = UIAlertAction(title: "받아오기", style: .default) { [weak self] _ in
                self?.download()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(uploadAction)
            alert.addAction(downloadAction)
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        initAppearance()
    }
    
    private func initAppearance() {
        view.backgroundColor = UIConfig.backgroundColor
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(editingButton)
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(dropboxButton)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            logoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.65),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
        ])
    }
}

//MARK: - Dropbox
extension MainViewController {
    private func upload() {
        DropboxManager.shared.upload(onComplete: { [weak self] in
            self?.presentBasicAlert(message: "업로드 성공")
        }, onError: { [weak self] errorMessage in
            self?.presentBasicAlert(message: errorMessage)
        })
    }
    
    private func download() {
        DropboxManager.shared.download(onComplete: { [weak self] in
            self?.presentBasicAlert(message: "다운로드 성공")
        }, onError: { [weak self] errorMessage in
            self?.presentBasicAlert(message: errorMessage)
        })
    }
}
