import UIKit

class StudyingViewController: UIViewController {
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
        initAction()
        initState()
        GoogleDriveManager.shared.upload(onComplete: {}, onError: {})
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
    
    private func initAction() {
        SentenceViewModel.shared.onNext.append { [weak self] newSentence in
            guard let newSentence = newSentence else { return }
            self?.koreanView.textView.text = newSentence.korean
            self?.englishView.textView.text = newSentence.english
            self?.englishView.textView.textColor = self?.englishView.textView.backgroundColor
        }

        SentenceViewModel.shared.onUpdate.append { [weak self] id, korean, english in
            guard id == SentenceViewModel.shared.currentSentence?.id else {
                return
            }
            self?.koreanView.textView.text = korean
            self?.englishView.textView.text = english
        }
        
        SentenceViewModel.shared.onDelete.append {
            SentenceViewModel.shared.toNext()
        }

        showSolutionButton.addTarget(self, action: #selector(toggleEnglishHiding), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(updateNextSentence), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(presentOption)
        )
    }
    
    @objc private func toggleEnglishHiding() {
        if englishView.textView.textColor == .label {
            englishView.textView.textColor = englishView.textView.backgroundColor
        } else {
            englishView.textView.textColor = .label
        }
    }
    
    @objc private func updateNextSentence() {
        SentenceViewModel.shared.toNext()
    }
    
    @objc private func presentOption() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            let updatingVC = UpdatingViewController()
            updatingVC.sentenceId = SentenceViewModel.shared.currentSentence?.id
            self?.present(updatingVC, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            guard let sentenceId = SentenceViewModel.shared.currentSentence?.id else {
                return
            }
            SentenceViewModel.shared.delete(id: sentenceId)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func initState() {
        SentenceViewModel.shared.toNext()
    }
}
