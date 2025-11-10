import UIKit

/// LoginRouter handles navigation for the Login screen.
/// Responsible for creating the module and navigating to other screens.
final class LoginRouter {
    
    // MARK: - VIPER Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Initializer
    
    init() {}
}

// MARK: - LoginRouterProtocol

extension LoginRouter: LoginRouterProtocol {
    /// Creates and returns the fully configured Login module
    static func createModule() -> UIViewController {
        print("🏗️ LoginRouter: Creating Login module")
        
        // Create VIPER components
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginRouter()
        
        // Connect VIPER components (Dependency Injection)
        
        // View
        view.presenter = presenter
        
        // Presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        // Interactor
        interactor.presenter = presenter
        interactor.output = presenter // Set output for callbacks
        
        // Router
        router.viewController = view
        
        print("✅ LoginRouter: Module created and configured")
        
        return view
    }
    
    func navigateToRegister() {
        print("🧭 LoginRouter: Navigating to Register screen")
        
        // Create Register module
        let registerModule = RegisterRouter.createModule()
        
        // Push to navigation stack
        viewController?.navigationController?.pushViewController(registerModule, animated: true)
    }
    
    func navigateToForgotPassword() {
        print("🧭 LoginRouter: Navigating to Forgot Password")
        
        // TODO: Implementar navegação para ForgotPassword quando o módulo existir
        // Por enquanto, mostra um alert
        showPlaceholderAlert(
            title: "Recuperar Senha",
            message: "A recuperação de senha será implementada em breve.\n\nPor enquanto, você pode usar o Firebase Console para resetar senhas manualmente."
        )
    }
    
    func navigateToMainScreen() {
        print("🧭 LoginRouter: Navigating to Main Screen (TabBar)")
        
        // Create main tab bar controller
        let tabBarController = MainTabBarController.create()
        
        // Replace the entire navigation stack
        if let navigationController = viewController?.navigationController {
            navigationController.setViewControllers([tabBarController], animated: true)
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first {
            window.rootViewController = tabBarController
            UIView.transition(with: window,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: nil)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Shows a placeholder alert for unimplemented features
    private func showPlaceholderAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    /// Shows a success alert with completion handler
    private func showSuccessAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        viewController?.present(alert, animated: true)
    }
    
    /// Shows a placeholder for the main screen
    private func showMainScreenPlaceholder() {
        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .systemBackground
        mainVC.title = "Exames"
        
        let label = UILabel()
        label.text = "📋 Tela Principal\n(Exames List)\n\nSerá implementada nos próximos módulos"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        mainVC.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: mainVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: mainVC.view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: mainVC.view.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: mainVC.view.trailingAnchor, constant: -40)
        ])
        
        // Adiciona botão de logout
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Sair", for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        mainVC.view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: mainVC.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: mainVC.view.trailingAnchor, constant: -20)
        ])
        
        // Navigate
        if let navigationController = viewController?.navigationController {
            navigationController.setViewControllers([mainVC], animated: true)
        }
    }
    
    @objc private func handleLogout() {
        print("🚪 LoginRouter: Logging out")
        
        // Sign out do Firebase
        do {
            try FirebaseManager.shared.signOut()
            
            // Volta para o login
            if let navigationController = viewController?.navigationController {
                let loginVC = LoginRouter.createModule()
                navigationController.setViewControllers([loginVC], animated: true)
            }
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }
}

