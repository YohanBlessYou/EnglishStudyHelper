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
        SentenceViewModel.shared.onCreate.append ({ [weak self] in
            self?.tableView.reloadData()
        })
        SentenceViewModel.shared.onUpdate.append ({ [weak self] _,_,_ in
            self?.tableView.reloadData()
        })
        SentenceViewModel.shared.onDelete.append ({ [weak self] in
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
        var configuration = cell.defaultContentConfiguration()
        configuration.text = SentenceViewModel.shared.sentences[indexPath.row].korean
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editingAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            let updatingVC = UpdatingViewController()
            updatingVC.sentenceId = SentenceViewModel.shared.sentences[indexPath.row].id
            self?.present(updatingVC, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            guard let sentenceId = SentenceViewModel.shared.sentences[indexPath.row].id else {
                return
            }
            SentenceViewModel.shared.delete(id: sentenceId)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(editingAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
}
