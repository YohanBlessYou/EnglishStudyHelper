import UIKit
import GoogleSignIn

class MainViewController: UIViewController {
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("편집", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문장추가", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let googleLoginButton: ButtonStyleView = {
        let icon = UIImage(named: "GoogleIcon")!
        let view = ButtonStyleView(image: icon, title: "Google Login", action: nil)
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
        initState()
    }
    
    private func initAppearance() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [
            startButton,
            editingButton,
            addButton,
            googleLoginButton
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                             multiplier: 0.7),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func initAction() {
        startButton.addTarget(self, action: #selector(presentStudyingVC), for: .touchUpInside)
        editingButton.addTarget(self, action: #selector(presentEditingVC), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(presentSentenceAddingVC), for: .touchUpInside)
        googleLoginButton.onTouch = { [weak self] in
            GoogleDriveManager.shared.toggleAuthentication(target: self
            , onLoggedIn: {
                self?.googleLoginButton.titleLabel.text = "Google Logout"
            }, onLoggedOut: {
                self?.googleLoginButton.titleLabel.text = "Google Login"
            }, onError: {
                self?.presentBasicAlert(message: "로그인실패")
            })
        }
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
    
    private func initState() {
        if GoogleDriveManager.shared.isLoggedIn {
            googleLoginButton.titleLabel.text = "Google Logout"
        } else {
            googleLoginButton.titleLabel.text = "Google Login"
        }
    }
}
