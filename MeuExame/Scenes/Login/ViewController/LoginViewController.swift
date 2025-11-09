import UIKit

/// LoginViewController é o View Controller da tela de login.
/// Segue o padrão VIPER, gerenciando apenas a LoginView e repassando eventos para o Presenter.
final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Referência ao Presenter (será injetado pelo Router)
    var presenter: PresenterProtocol?
    
    /// View customizada de Login
    private let loginView = LoginView()
    
    // MARK: - Private Helpers
    
    private var loginPresenter: LoginPresenterProtocol? {
        return presenter as? LoginPresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = loginView
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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        // Obter credenciais
        let credentials = loginView.getCredentials()
        
        // Repassar para o Presenter (que fará a validação e business logic)
        loginPresenter?.didTapLogin(email: credentials.email, password: credentials.password)
    }
    
    @objc private func registerButtonTapped() {
        // Repassar para o Presenter
        loginPresenter?.didTapRegister()
    }
    
    @objc private func forgotPasswordButtonTapped() {
        // Repassar para o Presenter
        loginPresenter?.didTapForgotPassword()
    }
}

// MARK: - LoginViewProtocol

extension LoginViewController: LoginViewProtocol {
    func getCredentials() -> (email: String, password: String) {
        return loginView.getCredentials()
    }
    
    func validateFields() -> (isValid: Bool, errorMessage: String?) {
        return loginView.validateFields()
    }
    
    func clearFields() {
        loginView.clearFields()
    }
    
    // MARK: - ViewProtocol (inherited from LoginViewProtocol)
    
    func showLoading() {
        loginView.showLoading()
    }
    
    func hideLoading() {
        loginView.hideLoading()
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

