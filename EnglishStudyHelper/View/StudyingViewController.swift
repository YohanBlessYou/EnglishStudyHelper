import UIKit

class StudyingViewController: UIViewController {

    private var sentenceViewModel = SentenceViewModel()
    private let koreanView = SimpleSquareView(title: "한국어 문장", isEditable: false)
    private let englishView = SimpleSquareView(title: "영어 문장", isEditable: false)
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
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(koreanView)
        stackView.addArrangedSubview(englishView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func initAction() {
        sentenceViewModel.addAction { [weak self] sentence in
            self?.koreanView.textView.text = sentence.korean
            self?.englishView.textView.text = sentence.english
        }
        sentenceViewModel.toNext()
    }
}