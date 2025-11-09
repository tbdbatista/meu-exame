import UIKit

/// LoginViewController é o View Controller da tela de login.
/// Segue o padrão VIPER, gerenciando apenas a LoginView e repassando eventos para o Presenter.
final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Referência ao Presenter (será injetado pelo Router)
    var presenter: PresenterProtocol?
    
    /// View customizada de Login
    private let loginView = LoginView()
    
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
        // Validar campos
        let validation = loginView.validateFields()
        
        guard validation.isValid else {
            showError(title: "Erro de Validação", message: validation.errorMessage ?? "Campos inválidos")
            return
        }
        
        // Obter credenciais
        let credentials = loginView.getCredentials()
        
        // Repassar para o Presenter
        // TODO: Implementar método no Presenter
        // presenter?.login(email: credentials.email, password: credentials.password)
        
        // TEMPORÁRIO: Feedback visual
        loginView.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.loginView.hideLoading()
            self?.showSuccess(
                title: "Login",
                message: "Email: \(credentials.email)\nSenha: \(String(repeating: "*", count: credentials.password.count))"
            )
        }
    }
    
    @objc private func registerButtonTapped() {
        // Repassar para o Presenter
        // TODO: Implementar método no Presenter
        // presenter?.navigateToRegister()
        
        // TEMPORÁRIO: Feedback visual
        showSuccess(title: "Cadastro", message: "Navegação para cadastro será implementada")
    }
    
    @objc private func forgotPasswordButtonTapped() {
        // Repassar para o Presenter
        // TODO: Implementar método no Presenter
        // presenter?.navigateToForgotPassword()
        
        // TEMPORÁRIO: Feedback visual
        showAlert(
            title: "Esqueci minha senha",
            message: "Recuperação de senha será implementada",
            actions: [
                UIAlertAction(title: "OK", style: .default)
            ]
        )
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}

// MARK: - ViewProtocol

extension LoginViewController: ViewProtocol {
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

