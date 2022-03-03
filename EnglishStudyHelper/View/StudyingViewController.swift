import UIKit

class StudyingViewController: UIViewController {

    private var sentenceViewModel = SentenceViewModel()
    private let koreanView: SimpleSquareView = {
        let view = SimpleSquareView(title: "한국어 문장", isEditable: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    private let englishView: SimpleSquareView = {
        let view = SimpleSquareView(title: "영어 문장", isEditable: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

    private let showSolutionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("정답보기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음문장", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
        registerAction()
        initState()
    }

    private func initAppearance() {
        view.backgroundColor = .systemBackground

        view.addSubview(koreanView)
        view.addSubview(showSolutionButton)
        view.addSubview(nextButton)
        view.addSubview(englishView)
        NSLayoutConstraint.activate([
            koreanView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            koreanView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            koreanView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            koreanView.bottomAnchor.constraint(equalTo: showSolutionButton.topAnchor, constant: -10),
            showSolutionButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            showSolutionButton.leadingAnchor.constraint(equalTo: koreanView.leadingAnchor),
            showSolutionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -5),
            nextButton.centerYAnchor.constraint(equalTo: showSolutionButton.centerYAnchor),
            nextButton.heightAnchor.constraint(equalTo: showSolutionButton.heightAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 5),
            nextButton.trailingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.trailingAnchor),
            englishView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            englishView.leadingAnchor.constraint(equalTo: koreanView.leadingAnchor),
            englishView.trailingAnchor.constraint(equalTo: koreanView.trailingAnchor),
            englishView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerAction() {
        sentenceViewModel.addAction { [weak self] sentence in
            self?.koreanView.textView.text = sentence.korean
            self?.englishView.textView.text = sentence.english
        } solutionHiddenAction: { [weak self] isHidden in
            if isHidden {
                self?.englishView.textView.textColor = self?.englishView.textView.backgroundColor
            } else {
                self?.englishView.textView.textColor = .label
            }
        }
        
        showSolutionButton.addTarget(self, action: #selector(toggleSolutionHiding), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(updateNextSentence), for: .touchUpInside)
    }
    
    @objc private func toggleSolutionHiding() {
        sentenceViewModel.solutionIsHidden.toggle()
    }
    
    @objc private func updateNextSentence() {
        sentenceViewModel.toNext()
    }
    
    private func initState() {
        sentenceViewModel.toNext()
    }
}
