import UIKit

/// HomeViewController é o View Controller da tela principal (Home).
/// Segue o padrão VIPER, gerenciando apenas a HomeView e repassando eventos para o Presenter.
final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Referência ao Presenter (será injetado pelo Router)
    var presenter: PresenterProtocol?
    
    /// View customizada de Home
    private let homeView = HomeView()
    
    // MARK: - Private Helpers
    
    private var homePresenter: HomePresenterProtocol? {
        return presenter as? HomePresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = homeView
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        // Hide navigation bar on Home (tem o header próprio)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupActions() {
        homeView.addExamButton.addTarget(self, action: #selector(addExamButtonTapped), for: .touchUpInside)
        homeView.aboutButton.addTarget(self, action: #selector(aboutButtonTapped), for: .touchUpInside)
        
        // Profile image tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        homeView.profileImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func addExamButtonTapped() {
        print("📋 HomeViewController: Add Exam button tapped")
        homePresenter?.didTapAddExam()
    }
    
    @objc private func aboutButtonTapped() {
        print("ℹ️ HomeViewController: About button tapped")
        homePresenter?.didTapAbout()
    }
    
    @objc private func profileImageTapped() {
        print("👤 HomeViewController: Profile image tapped")
        homePresenter?.didTapProfile()
    }
}

// MARK: - HomeViewProtocol

extension HomeViewController: HomeViewProtocol {
    func updateExamSummary(_ summary: ExamSummary) {
        homeView.updateSummary(summary)
    }
    
    func updateUserProfile(_ profile: UserProfile) {
        homeView.updateProfile(profile)
    }
    
    func updateScheduledExams(_ exams: [ExameModel]) {
        // TODO: Update HomeView to display scheduled exams
        // For now, just log them
        print("📅 HomeViewController: Received \(exams.count) scheduled exams")
    }
    
    // MARK: - ViewProtocol (inherited from HomeViewProtocol)
    
    func showLoading() {
        // Pode usar indicator no centro ou pull-to-refresh
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = self.view.center
            activityIndicator.tag = 999
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let activityIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            self.view.isUserInteractionEnabled = true
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

