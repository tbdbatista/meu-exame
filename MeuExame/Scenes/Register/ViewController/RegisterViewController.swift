import UIKit

/// RegisterViewController é o View Controller da tela de cadastro.
/// Segue o padrão VIPER, gerenciando apenas a RegisterView e repassando eventos para o Presenter.
final class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Referência ao Presenter (será injetado pelo Router)
    var presenter: PresenterProtocol?
    
    /// View customizada de Register
    private let registerView = RegisterView()
    
    // MARK: - Private Helpers
    
    private var registerPresenter: RegisterPresenterProtocol? {
        return presenter as? RegisterPresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        setupKeyboardDismissal()
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
        // Configurar navigation bar para mostrar botão de voltar
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = ""
        
        // Personalizar cor do botão de voltar
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    private func setupActions() {
        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerView.backToLoginButton.addTarget(self, action: #selector(backToLoginButtonTapped), for: .touchUpInside)
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func registerButtonTapped() {
        // Obter credenciais
        let credentials = registerView.getCredentials()
        
        // Repassar para o Presenter (que fará a validação e business logic)
        registerPresenter?.didTapRegister(
            email: credentials.email,
            password: credentials.password,
            confirmPassword: credentials.confirmPassword
        )
    }
    
    @objc private func backToLoginButtonTapped() {
        // Repassar para o Presenter
        registerPresenter?.didTapBackToLogin()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - RegisterViewProtocol

extension RegisterViewController: RegisterViewProtocol {
    func getCredentials() -> (email: String, password: String, confirmPassword: String) {
        return registerView.getCredentials()
    }
    
    func validateFields() -> (isValid: Bool, errorMessage: String?) {
        return registerView.validateFields()
    }
    
    func clearFields() {
        registerView.clearFields()
    }
    
    // MARK: - ViewProtocol (inherited from RegisterViewProtocol)
    
    func showLoading() {
        registerView.showLoading()
    }
    
    func hideLoading() {
        registerView.hideLoading()
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

