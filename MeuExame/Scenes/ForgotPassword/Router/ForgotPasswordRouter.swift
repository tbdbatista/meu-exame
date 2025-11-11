import UIKit

/// ForgotPasswordRouter é o Router da tela de recuperação de senha.
/// Segue o padrão VIPER, gerenciando navegação e montagem do módulo.
final class ForgotPasswordRouter {
    
    // MARK: - VIPER Property
    
    weak var viewController: UIViewController?
}

// MARK: - RouterProtocol

extension ForgotPasswordRouter: RouterProtocol {
    static func createModule() -> UIViewController {
        print("🏗️ ForgotPasswordRouter: Criando módulo ForgotPassword")
        
        // Get auth service from Firebase Manager
        let authService = FirebaseManager.shared
        
        // Create components
        let view = ForgotPasswordViewController()
        let presenter = ForgotPasswordPresenter()
        let interactor = ForgotPasswordInteractor(authService: authService)
        let router = ForgotPasswordRouter()
        
        // Connect VIPER components
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.output = presenter
        
        router.viewController = view
        
        print("✅ ForgotPasswordRouter: Módulo criado com sucesso")
        return view
    }
}

// MARK: - ForgotPasswordRouterProtocol

extension ForgotPasswordRouter: ForgotPasswordRouterProtocol {
    func dismiss() {
        print("🧭 ForgotPasswordRouter: Dismissing forgot password screen")
        viewController?.navigationController?.popViewController(animated: true)
    }
}

