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
    
    private let koreanLabel: UILabel = {
        let label = UILabel()
        label.text = "한국어 문장"
        label.font = .preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private let koreanTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textView
    }()
    private let koreanStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let englishLabel: UILabel = {
        let label = UILabel()
        label.text = "영어 문장"
        label.font = .preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    private let englishTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        return textView
    }()
    private let englishStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    private func initViewController() {
        initAppearance()
        initAction()
    }
    
    private func initAppearance() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(addButton)
        view.addSubview(totalStackView)
        totalStackView.addArrangedSubview(koreanStackView)
        totalStackView.addArrangedSubview(englishStackView)
        koreanStackView.addArrangedSubview(koreanLabel)
        koreanStackView.addArrangedSubview(koreanTextView)
        englishStackView.addArrangedSubview(englishLabel)
        englishStackView.addArrangedSubview(englishTextView)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalStackView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30),
            totalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            totalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func initAction() {
        addButton.addTarget(self, action: #selector(addSentence), for: .touchUpInside)
    }
    
    @objc private func addSentence() {
        guard koreanTextView.isOnlyKorean else {
            return
        }
        guard englishTextView.isOnlyEnglish else {
            return
        }
    }
}
