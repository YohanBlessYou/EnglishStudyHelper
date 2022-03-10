import UIKit

class AddingViewController: UIViewController {
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let koreanView: SimpleSquareView = {
        let view = SimpleSquareView(title: "한국어 문장")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    private let papagoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("파파고번역", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    private let englishView: SimpleSquareView = {
        let view = SimpleSquareView(title: "영어 문장")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
        initAction()
    }

    private func initAppearance() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(addButton)
        view.addSubview(koreanView)
        view.addSubview(papagoButton)
        view.addSubview(englishView)

        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            koreanView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            koreanView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            koreanView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            koreanView.bottomAnchor.constraint(equalTo: papagoButton.topAnchor, constant: -10),

            papagoButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            papagoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            papagoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            englishView.topAnchor.constraint(equalTo: papagoButton.bottomAnchor, constant: 10),
            englishView.leadingAnchor.constraint(equalTo: koreanView.leadingAnchor),
            englishView.trailingAnchor.constraint(equalTo: koreanView.trailingAnchor),
            englishView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func initAction() {
        addButton.addTarget(self, action: #selector(addSentence), for: .touchUpInside)
        papagoButton.addTarget(self, action: #selector(requestTranslation), for: .touchUpInside)
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
        SentenceViewModel.shared.create(korean: koreanView.textView.text, english: englishView.textView.text)
        dismiss(animated: true)
    }
    
    @objc private func requestTranslation() {
        PapagoManager().translate(korean: koreanView.textView.text) { data in
            
        }
    }
}
