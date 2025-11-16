import UIKit

/// ScheduledExamsListViewController é o View Controller da tela de listagem de exames agendados.
/// Segue o padrão VIPER, gerenciando a View e repassando eventos para o Presenter.
final class ScheduledExamsListViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PresenterProtocol?
    private let scheduledExamsListView = ScheduledExamsListView()
    
    // MARK: - Private Helpers
    
    private var scheduledExamsListPresenter: ScheduledExamsListPresenterProtocol? {
        return presenter as? ScheduledExamsListPresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = scheduledExamsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Exames Agendados"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupActions() {
        // Refresh control
        scheduledExamsListView.refreshControl.addTarget(
            self,
            action: #selector(refreshControlTriggered),
            for: .valueChanged
        )
        
        // Exam selection
        scheduledExamsListView.onExamSelected = { [weak self] exame in
            self?.scheduledExamsListPresenter?.didSelectExam(exame)
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshControlTriggered() {
        scheduledExamsListPresenter?.didPullToRefresh()
    }
}

// MARK: - ScheduledExamsListViewProtocol

extension ScheduledExamsListViewController: ScheduledExamsListViewProtocol {
    func updateScheduledExams(_ exams: [ExameModel]) {
        scheduledExamsListView.updateScheduledExams(exams)
        scheduledExamsListView.refreshControl.endRefreshing()
    }
    
    func showEmptyState(_ message: String) {
        scheduledExamsListView.showEmptyState(message)
        scheduledExamsListView.refreshControl.endRefreshing()
    }
    
    func hideEmptyState() {
        scheduledExamsListView.hideEmptyState()
    }
    
    // MARK: - ViewProtocol
    
    func showLoading() {
        if !scheduledExamsListView.refreshControl.isRefreshing {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = view.center
            activityIndicator.tag = 999
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        scheduledExamsListView.refreshControl.endRefreshing()
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

