import UIKit

class SentenceAddingViewController: UIViewController {
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let koreanView = SimpleSquareView(title: "한국어 문장", isEditable: true)
    private let englishView = SimpleSquareView(title: "영어 문장", isEditable: true)

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
        initAction()
    }

    private func initAppearance() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(addButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(koreanView)
        stackView.addArrangedSubview(englishView)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func initAction() {
        addButton.addTarget(self, action: #selector(addSentence), for: .touchUpInside)
    }
    
    @objc private func addSentence() {
        guard koreanView.textView.isOnlyKorean else {
            UIAlertController.Basic.warning(target: self, message: "한국어 입력이 잘못되었습니다")
            return
        }
        guard englishView.textView.isOnlyEnglish else {
            UIAlertController.Basic.warning(target: self, message: "영어 입력이 잘못되었습니다")
            return
        }
        SentenceDataManager.shared.create(korean: koreanView.textView.text, english: englishView.textView.text)
        dismiss(animated: true)
    }
}
