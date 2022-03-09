import UIKit

class SentenceEditingViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = SentenceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
        initTableView()
        registerAction()
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
    
    private func registerAction() {
        viewModel.sentencesActions.append({ [weak self] in
            self?.tableView.reloadData()
        })
    }
}

extension SentenceEditingViewController: UITableViewDataSource, UITableViewDelegate {
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sentences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var configuration = cell.defaultContentConfiguration()
        configuration.text = viewModel.sentences[indexPath.row].korean
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sentence = viewModel.sentences[indexPath.row]
        viewModel.deleteSentence(id: sentence.id!)
    }
}
