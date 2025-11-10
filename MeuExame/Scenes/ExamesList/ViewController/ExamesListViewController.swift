import UIKit

/// ExamesListViewController é o View Controller da tela de listagem de exames.
/// Segue o padrão VIPER, gerenciando a View e repassando eventos para o Presenter.
final class ExamesListViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PresenterProtocol?
    private let examesListView = ExamesListView()
    
    // MARK: - Private Helpers
    
    private var examesListPresenter: ExamesListPresenterProtocol? {
        return presenter as? ExamesListPresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = examesListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        setupSearchBar()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Meus Exames"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add button
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
        
        // Filter button (optional)
        // let filterButton = UIBarButtonItem(
        //     image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
        //     style: .plain,
        //     target: self,
        //     action: #selector(filterButtonTapped)
        // )
        // navigationItem.leftBarButtonItem = filterButton
    }
    
    private func setupActions() {
        // Refresh control
        examesListView.refreshControl.addTarget(
            self,
            action: #selector(refreshControlTriggered),
            for: .valueChanged
        )
        
        // Exam selection
        examesListView.onExamSelected = { [weak self] exame in
            self?.examesListPresenter?.didSelectExam(exame)
        }
        
        // Exam deletion
        examesListView.onDeleteExam = { [weak self] exame in
            self?.confirmDelete(exame)
        }
    }
    
    private func setupSearchBar() {
        examesListView.searchBar.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        examesListPresenter?.didTapAddExam()
    }
    
    @objc private func filterButtonTapped() {
        examesListPresenter?.didTapFilter()
    }
    
    @objc private func refreshControlTriggered() {
        examesListPresenter?.didPullToRefresh()
    }
    
    private func confirmDelete(_ exame: ExameModel) {
        let alert = UIAlertController(
            title: "Excluir Exame",
            message: "Deseja realmente excluir o exame \"\(exame.nome)\"?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Excluir", style: .destructive) { [weak self] _ in
            // TODO: Call presenter to delete
            print("🗑️ Delete exame: \(exame.nome)")
        })
        
        present(alert, animated: true)
    }
}

// MARK: - ExamesListViewProtocol

extension ExamesListViewController: ExamesListViewProtocol {
    func updateExames(_ exams: [ExameModel]) {
        examesListView.updateExames(exams)
        examesListView.refreshControl.endRefreshing()
    }
    
    func showEmptyState(_ message: String) {
        examesListView.showEmptyState(message)
        examesListView.refreshControl.endRefreshing()
    }
    
    func hideEmptyState() {
        examesListView.hideEmptyState()
    }
    
    func updateSearchResults(_ filteredExams: [ExameModel]) {
        examesListView.updateExames(filteredExams)
    }
    
    // MARK: - ViewProtocol
    
    func showLoading() {
        // Table view loading handled by refresh control
        if !examesListView.refreshControl.isRefreshing {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = view.center
            activityIndicator.tag = 999
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        examesListView.refreshControl.endRefreshing()
        if let activityIndicator = view.viewWithTag(999) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func showError(title: String, message: String) {
        hideLoading()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(title: String, message: String) {
        hideLoading()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ExamesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            examesListPresenter?.didCancelSearch()
        } else {
            examesListPresenter?.didSearch(with: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        examesListPresenter?.didCancelSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

