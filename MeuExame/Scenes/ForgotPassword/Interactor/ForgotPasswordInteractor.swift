import Foundation

/// ForgotPasswordInteractor é o Interactor da tela de recuperação de senha.
/// Segue o padrão VIPER, gerenciando a lógica de negócios e comunicação com serviços.
final class ForgotPasswordInteractor {
    
    // MARK: - VIPER Properties (Base Protocol)
    
    weak var presenter: PresenterProtocol?
    
    // MARK: - Private Properties
    
    weak var output: ForgotPasswordInteractorOutputProtocol?
    private let authService: AuthServiceProtocol
    
    // MARK: - Initializer
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}

// MARK: - InteractorProtocol

extension ForgotPasswordInteractor: InteractorProtocol {
    // Base protocol conformance
}

// MARK: - ForgotPasswordInteractorProtocol

extension ForgotPasswordInteractor: ForgotPasswordInteractorProtocol {
    func sendPasswordResetEmail(email: String) {
        print("📧 ForgotPasswordInteractor: Enviando e-mail de redefinição para: \(email)")
        
        authService.sendPasswordReset(email: email) { [weak self] result in
            switch result {
            case .success:
                print("✅ ForgotPasswordInteractor: E-mail enviado com sucesso")
                self?.output?.passwordResetEmailDidSend()
                
            case .failure(let error):
                print("❌ ForgotPasswordInteractor: Erro ao enviar e-mail - \(error.localizedDescription)")
                self?.output?.passwordResetEmailDidFail(error: error)
            }
        }
    }
}

