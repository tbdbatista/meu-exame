import Foundation

/// ForgotPasswordPresenter é o Presenter da tela de recuperação de senha.
/// Segue o padrão VIPER, mediando a comunicação entre View, Interactor e Router.
final class ForgotPasswordPresenter {
    
    // MARK: - VIPER Properties (Base Protocols)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Private Helpers
    
    private var forgotPasswordView: ForgotPasswordViewProtocol? {
        return view as? ForgotPasswordViewProtocol
    }
    
    private var forgotPasswordInteractor: ForgotPasswordInteractorProtocol? {
        return interactor as? ForgotPasswordInteractorProtocol
    }
    
    private var forgotPasswordRouter: ForgotPasswordRouterProtocol? {
        return router as? ForgotPasswordRouterProtocol
    }
}

// MARK: - PresenterProtocol

extension ForgotPasswordPresenter: PresenterProtocol {
    func viewDidLoad() {
        print("🔐 ForgotPasswordPresenter: View carregada")
    }
    
    func viewWillAppear() {
        print("🔐 ForgotPasswordPresenter: View irá aparecer")
    }
}

// MARK: - ForgotPasswordPresenterProtocol

extension ForgotPasswordPresenter: ForgotPasswordPresenterProtocol {
    func didTapSendResetLink(email: String?) {
        print("🔐 ForgotPasswordPresenter: Enviar link de redefinição")
        
        // Validate email
        guard let email = email, !email.isEmpty else {
            forgotPasswordView?.showEmailError("Por favor, insira seu e-mail")
            return
        }
        
        guard isValidEmail(email) else {
            forgotPasswordView?.showEmailError("Por favor, insira um e-mail válido")
            return
        }
        
        forgotPasswordView?.hideEmailError()
        view?.showLoading()
        
        print("🔐 ForgotPasswordPresenter: Enviando para: \(email)")
        forgotPasswordInteractor?.sendPasswordResetEmail(email: email)
    }
    
    func didTapBack() {
        print("🔐 ForgotPasswordPresenter: Voltar")
        forgotPasswordRouter?.dismiss()
    }
    
    // MARK: - Validation
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - ForgotPasswordInteractorOutputProtocol

extension ForgotPasswordPresenter: ForgotPasswordInteractorOutputProtocol {
    func passwordResetEmailDidSend() {
        print("✅ ForgotPasswordPresenter: E-mail de redefinição enviado")
        view?.hideLoading()
        view?.showSuccess(
            title: "E-mail Enviado!",
            message: "Verifique sua caixa de entrada e siga as instruções para redefinir sua senha."
        )
        forgotPasswordView?.clearEmail()
    }
    
    func passwordResetEmailDidFail(error: Error) {
        print("❌ ForgotPasswordPresenter: Erro ao enviar e-mail: \(error.localizedDescription)")
        view?.hideLoading()
        
        let errorMessage: String
        if let authError = error as? AuthError {
            errorMessage = authError.localizedDescription
        } else {
            errorMessage = "Não foi possível enviar o e-mail. Verifique se o endereço está correto e tente novamente."
        }
        
        view?.showError(
            title: "Erro ao Enviar",
            message: errorMessage
        )
    }
}

