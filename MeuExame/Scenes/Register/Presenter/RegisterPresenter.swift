import Foundation

/// RegisterPresenter handles the presentation logic for the Register screen.
/// It acts as the middleman between the View and the Interactor,
/// formatting data for display and delegating business logic.
final class RegisterPresenter {
    
    // MARK: - VIPER Properties (PresenterProtocol conformance)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Initializer
    
    init() {}
    
    // MARK: - Private Helpers
    
    private var registerView: RegisterViewProtocol? {
        return view as? RegisterViewProtocol
    }
    
    private var registerInteractor: RegisterInteractorProtocol? {
        return interactor as? RegisterInteractorProtocol
    }
    
    private var registerRouter: RegisterRouterProtocol? {
        return router as? RegisterRouterProtocol
    }
}

// MARK: - RegisterPresenterProtocol

extension RegisterPresenter: RegisterPresenterProtocol {
    func viewDidLoad() {
        // Initial setup if needed
        print("📱 RegisterPresenter: View did load")
    }
    
    func viewWillAppear() {
        // Setup when view appears
        print("📱 RegisterPresenter: View will appear")
    }
    
    func viewDidDisappear() {
        // Cleanup if needed
    }
    
    func didTapRegister(email: String, password: String, confirmPassword: String) {
        print("📱 RegisterPresenter: Register button tapped")
        
        // Validate inputs (presentation-level validation)
        guard !email.isEmpty else {
            registerView?.showError(title: "Erro", message: "Por favor, preencha o e-mail")
            return
        }
        
        guard isValidEmail(email) else {
            registerView?.showError(title: "Erro", message: "Por favor, insira um e-mail válido")
            return
        }
        
        guard !password.isEmpty else {
            registerView?.showError(title: "Erro", message: "Por favor, preencha a senha")
            return
        }
        
        guard password.count >= 6 else {
            registerView?.showError(title: "Erro", message: "A senha deve ter no mínimo 6 caracteres")
            return
        }
        
        guard !confirmPassword.isEmpty else {
            registerView?.showError(title: "Erro", message: "Por favor, confirme a senha")
            return
        }
        
        guard password == confirmPassword else {
            registerView?.showError(title: "Erro", message: "As senhas não coincidem")
            return
        }
        
        // Additional password strength validation
        if !isStrongPassword(password) {
            let alert = "A senha é fraca. Recomendamos usar letras maiúsculas, minúsculas, números e caracteres especiais."
            // Just a warning, not blocking
            print("⚠️ RegisterPresenter: \(alert)")
        }
        
        // Show loading
        registerView?.showLoading()
        
        // Delegate to Interactor for business logic
        registerInteractor?.performRegister(email: email, password: password)
    }
    
    func didTapBackToLogin() {
        print("📱 RegisterPresenter: Back to Login button tapped")
        registerRouter?.navigateBackToLogin()
    }
    
    func didTapTermsOfService() {
        print("📱 RegisterPresenter: Terms of Service tapped")
        registerRouter?.navigateToTermsOfService()
    }
    
    // MARK: - Helper Methods
    
    /// Validates email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Checks if password is strong (has uppercase, lowercase, and numbers)
    private func isStrongPassword(_ password: String) -> Bool {
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        return hasUppercase && hasLowercase && hasNumbers && password.count >= 8
    }
}

// MARK: - RegisterInteractorOutputProtocol

extension RegisterPresenter: RegisterInteractorOutputProtocol {
    func registerDidSucceed(userId: String) {
        print("✅ RegisterPresenter: Registration succeeded - User ID: \(userId)")
        
        // Hide loading
        registerView?.hideLoading()
        
        // Clear fields
        registerView?.clearFields()
        
        // Show success message
        registerView?.showSuccess(
            title: "Sucesso!",
            message: "Sua conta foi criada com sucesso! Você será redirecionado."
        )
        
        // Navigate to main screen after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.registerRouter?.navigateToMainScreen()
        }
    }
    
    func registerDidFail(error: Error) {
        print("❌ RegisterPresenter: Registration failed - Error: \(error.localizedDescription)")
        
        // Hide loading
        registerView?.hideLoading()
        
        // Format error message
        let errorMessage = formatErrorMessage(error)
        
        // Show error to user
        registerView?.showError(title: "Erro no Cadastro", message: errorMessage)
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

