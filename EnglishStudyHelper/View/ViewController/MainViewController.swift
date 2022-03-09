import UIKit

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
        view.addSubview(editingButton)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 100),
            startButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            startButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            editingButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 100),
            editingButton.heightAnchor.constraint(equalToConstant: 100),
            editingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            editingButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            addButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 100),
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func initAction() {
        startButton.addTarget(self, action: #selector(presentStudyingVC), for: .touchUpInside)
        editingButton.addTarget(self, action: #selector(presentEditingVC), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(presentSentenceAddingVC), for: .touchUpInside)
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

