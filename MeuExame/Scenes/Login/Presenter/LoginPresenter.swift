import Foundation

/// LoginPresenter handles the presentation logic for the Login screen.
/// It acts as the middleman between the View and the Interactor,
/// formatting data for display and delegating business logic.
final class LoginPresenter {
    
    // MARK: - VIPER Properties (PresenterProtocol conformance)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Initializer
    
    init(
        view: ViewProtocol? = nil,
        interactor: InteractorProtocol? = nil,
        router: RouterProtocol? = nil
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Private Helpers
    
    private var loginView: LoginViewProtocol? {
        return view as? LoginViewProtocol
    }
    
    private var loginInteractor: LoginInteractorProtocol? {
        return interactor as? LoginInteractorProtocol
    }
    
    private var loginRouter: LoginRouterProtocol? {
        return router as? LoginRouterProtocol
    }
}

// MARK: - LoginPresenterProtocol

extension LoginPresenter: LoginPresenterProtocol {
    func viewDidLoad() {
        // Initial setup if needed
        print("📱 LoginPresenter: View did load")
    }
    
    func didTapLogin(email: String, password: String) {
        print("📱 LoginPresenter: Login button tapped")
        
        // Validate inputs (presentation-level validation)
        guard !email.isEmpty else {
            loginView?.showError(title: "Erro", message: "Por favor, preencha o e-mail")
            return
        }
        
        guard !password.isEmpty else {
            loginView?.showError(title: "Erro", message: "Por favor, preencha a senha")
            return
        }
        
        guard isValidEmail(email) else {
            loginView?.showError(title: "Erro", message: "Por favor, insira um e-mail válido")
            return
        }
        
        guard password.count >= 6 else {
            loginView?.showError(title: "Erro", message: "A senha deve ter no mínimo 6 caracteres")
            return
        }
        
        loginView?.showLoading()
        
        loginInteractor?.performLogin(email: email, password: password)
    }
    
    func didTapRegister() {
        print("📱 LoginPresenter: Register button tapped")
        loginRouter?.navigateToRegister()
    }
    
    func didTapForgotPassword() {
        print("📱 LoginPresenter: Forgot password button tapped")
        loginRouter?.navigateToForgotPassword()
    }
    
    // MARK: - Helper Methods
    
    /// Validates email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - LoginInteractorOutputProtocol

extension LoginPresenter: LoginInteractorOutputProtocol {
    func loginDidSucceed(userId: String) {
        print("✅ LoginPresenter: Login succeeded - User ID: \(userId)")
        
        // Hide loading
        loginView?.hideLoading()
        
        // Clear fields
        loginView?.clearFields()
        
        // Show success message (optional, pode navegar direto)
        // loginView?.showSuccess(title: "Sucesso", message: "Login realizado com sucesso!")
        
        // Navigate to main screen
        loginRouter?.navigateToMainScreen()
    }
    
    func loginDidFail(error: Error) {
        print("❌ LoginPresenter: Login failed - Error: \(error.localizedDescription)")
        
        // Hide loading
        loginView?.hideLoading()
        
        // Format error message
        let errorMessage = formatErrorMessage(error)
        
        // Show error to user
        loginView?.showError(title: "Erro no Login", message: errorMessage)
    }
    
    // MARK: - Error Formatting
    
    /// Formats error messages for user display
    private func formatErrorMessage(_ error: Error) -> String {
        // Check if it's our custom AuthError
        if let authError = error as? AuthError {
            return authError.localizedDescription
        }
        
        // Convert Firebase error to AuthError
        let authError = error.asAuthError
        return authError.localizedDescription
    }
}

