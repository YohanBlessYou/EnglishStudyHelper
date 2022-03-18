import UIKit
import GoogleSignIn

class MainViewController: UIViewController {
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("편집", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문장추가", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var googleUploadingButton: ButtonStyleView = {
        let icon = UIImage(named: "GoogleIcon")!
        let view = ButtonStyleView(image: icon, title: "클라우드 업로드") { [weak self] in
            guard let target = self else { return }
            GoogleDriveViewModel.shared.upload(target: target)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var googleDownloadingButton: ButtonStyleView = {
        let icon = UIImage(named: "GoogleIcon")!
        let view = ButtonStyleView(image: icon, title: "클라우드 다운로드") { [weak self] in
            guard let target = self else { return }
            GoogleDriveViewModel.shared.download(target: target)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        initAppearance()
        initAction()
    }
    
    private func initAppearance() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [
            startButton,
            editingButton,
            addButton,
            googleUploadingButton,
            googleDownloadingButton
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func initAction() {
        startButton.addTarget(self, action: #selector(presentStudyingVC), for: .touchUpInside)
        editingButton.addTarget(self, action: #selector(presentEditingVC), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(presentSentenceAddingVC), for: .touchUpInside)
        
        GoogleDriveViewModel.shared.registerHandler(onUpload: { [weak self] in
            self?.presentBasicAlert(message: "업로드 성공")
        }, onDownload: { [weak self] in
            self?.presentBasicAlert(message: "다운로드 성공")
        }, onError: { [weak self] in
            self?.presentBasicAlert(message: "에러 발생")
        })
    }
    
    @objc private func presentStudyingVC() {
        navigationController?.pushViewController(StudyingViewController(), animated: true)
    }
    
    @objc private func presentEditingVC() {
        navigationController?.pushViewController(EditingViewController(), animated: true)
    }
    
    @objc private func presentSentenceAddingVC() {
        present(AddingViewController(), animated: true)
    }
}
