import UIKit

/// ForgotPasswordViewController é o View Controller da tela de recuperação de senha.
/// Segue o padrão VIPER, gerenciando a View e repassando eventos para o Presenter.
final class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PresenterProtocol?
    private let forgotPasswordView = ForgotPasswordView()
    
    // MARK: - Private Helpers
    
    private var forgotPasswordPresenter: ForgotPasswordPresenterProtocol? {
        return presenter as? ForgotPasswordPresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Recuperar Senha"
        
        // Back button (default iOS back button is enough, but we can customize if needed)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    private func setupActions() {
        forgotPasswordView.onSendResetLinkTapped = { [weak self] email in
            self?.forgotPasswordPresenter?.didTapSendResetLink(email: email)
        }
    }
}

// MARK: - ForgotPasswordViewProtocol

extension ForgotPasswordViewController: ForgotPasswordViewProtocol {
    func clearEmail() {
        forgotPasswordView.clearEmail()
    }
    
    func showEmailError(_ message: String) {
        forgotPasswordView.showEmailError(message)
    }
    
    func hideEmailError() {
        forgotPasswordView.hideEmailError()
    }
    
    // MARK: - ViewProtocol
    
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.tag = 999
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        view.isUserInteractionEnabled = false
        forgotPasswordView.sendButton.isEnabled = false
        forgotPasswordView.sendButton.alpha = 0.5
    }
    
    func hideLoading() {
        if let activityIndicator = view.viewWithTag(999) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
        view.isUserInteractionEnabled = true
        forgotPasswordView.sendButton.isEnabled = true
        forgotPasswordView.sendButton.alpha = 1.0
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
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.forgotPasswordPresenter?.didTapBack()
        })
        present(alert, animated: true)
    }
}

