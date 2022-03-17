import UIKit

class EditingViewController: UIViewController {
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
        initTableView()
        initAction()
    }
    
    private func initAppearance() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func initAction() {
        SentenceViewModel.shared.registerHandler(onCreate: { [weak self] in
            self?.tableView.reloadData()
        }, onUpdate: { [weak self] _,_,_ in
            self?.tableView.reloadData()
        }, onDelete: { [weak self] in
            self?.tableView.reloadData()
        })
    }
}

extension EditingViewController: UITableViewDataSource, UITableViewDelegate {
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SentenceViewModel.shared.sentences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 10
        backgroundView.backgroundColor = .systemBlue
        cell.selectedBackgroundView = backgroundView
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = SentenceViewModel.shared.sentences[indexPath.row].korean
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editingAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            let selectedSentence = SentenceViewModel.shared.sentences[indexPath.row]
            SentenceViewModel.shared.selectedSentence = selectedSentence
            self?.present(UpdatingViewController(), animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let selectedSentence = SentenceViewModel.shared.sentences[indexPath.row]
            SentenceViewModel.shared.delete(id: selectedSentence.id!)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(editingAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
}
