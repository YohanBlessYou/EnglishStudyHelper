import UIKit

class UpdatingViewController: UIViewController {
    private let updatingButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
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
    
    var sentenceId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
        initAction()
        initState()
    }

    private func initAppearance() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(updatingButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(koreanView)
        stackView.addArrangedSubview(englishView)
        
        NSLayoutConstraint.activate([
            updatingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            updatingButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            updatingButton.heightAnchor.constraint(equalToConstant: 50),
            updatingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: updatingButton.bottomAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func initAction() {
        updatingButton.addTarget(self, action: #selector(updateSentence), for: .touchUpInside)
    }
    
    @objc private func updateSentence() {
        SentenceViewModel.shared.update(id: sentenceId!, korean: koreanView.textView.text, english: englishView.textView.text)
        dismiss(animated: true)
    }
    
    private func initState() {
        guard let sentenceId = sentenceId,
            let sentence = SentenceViewModel.shared.getSentence(fromId: sentenceId) else {
            return
        }
        
        koreanView.textView.text = sentence.korean
        englishView.textView.text = sentence.english
    }
}
