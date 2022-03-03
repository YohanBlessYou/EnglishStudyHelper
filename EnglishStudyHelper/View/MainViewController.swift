import UIKit

class MainViewController: UIViewController {
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemBlue
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
        
        view.addSubview(startButton)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 100),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            addButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 150),
            addButton.heightAnchor.constraint(equalTo: startButton.heightAnchor),
            addButton.centerXAnchor.constraint(equalTo: startButton.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo: startButton.widthAnchor)
        ])
    }
    
    private func initAction() {
        startButton.addTarget(self, action: #selector(presentStudyingVC), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(presentSentenceAddingVC), for: .touchUpInside)
    }
    
    @objc private func presentStudyingVC() {
        navigationController?.pushViewController(StudyingViewController(), animated: true)
    }
    
    @objc private func presentSentenceAddingVC() {
        present(SentenceAddingViewController(), animated: true)
    }
}

