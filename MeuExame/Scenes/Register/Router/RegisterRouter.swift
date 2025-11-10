import UIKit

/// RegisterRouter handles navigation and module assembly for the Register scene.
/// It is responsible for creating all VIPER components and injecting their dependencies.
final class RegisterRouter {
    
    // MARK: - VIPER Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Static Module Creation
    
    /// Creates and configures the Register VIPER module.
    /// - Returns: The entry point `UIViewController` for the Register module.
    static func createModule() -> UIViewController {
        print("🏗️ RegisterRouter: Creating Register module")
        
        // Create VIPER components
        let view = RegisterViewController()
        let presenter = RegisterPresenter()
        let interactor = RegisterInteractor()
        let router = RegisterRouter()
        
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
        
        print("✅ RegisterRouter: Module created and configured")
        
        return view
    }
}

// MARK: - RegisterRouterProtocol

extension RegisterRouter: RegisterRouterProtocol {
    func navigateBackToLogin() {
        print("🧭 RegisterRouter: Navigating back to Login screen")
        
        // Pop the view controller to go back to Login
        if let navigationController = viewController?.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            // Fallback: dismiss if presented modally
            viewController?.dismiss(animated: true)
        }
    }
    
    func navigateToTermsOfService() {
        print("🧭 RegisterRouter: Navigating to Terms of Service (placeholder)")
        
        // TODO: Implement Terms of Service screen
        let termsVC = UIViewController()
        termsVC.view.backgroundColor = .systemBackground
        termsVC.title = "Termos de Serviço"
        
        let textView = UITextView()
        textView.text = """
        Termos de Serviço
        
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        
        (Esta é uma tela placeholder. Implemente os termos reais aqui.)
        """
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        termsVC.view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: termsVC.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: termsVC.view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: termsVC.view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: termsVC.view.bottomAnchor, constant: -16)
        ])
        
        viewController?.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    func navigateToMainScreen() {
        print("🧭 RegisterRouter: Navigating to Main Screen (ExamesList)")
        
        // Placeholder for Main Screen
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .systemGreen
        mainViewController.title = "Exames"
        
        // Add a logout button for testing
        let logoutButton = UIBarButtonItem(title: "Sair", style: .plain, target: self, action: #selector(logoutTapped))
        mainViewController.navigationItem.rightBarButtonItem = logoutButton
        
        // Present the main screen
        if let navigationController = viewController?.navigationController {
            // Replace the entire navigation stack with the main screen
            navigationController.setViewControllers([mainViewController], animated: true)
        } else {
            viewController?.present(UINavigationController(rootViewController: mainViewController), animated: true)
        }
    }
    
    @objc private func logoutTapped() {
        print("🧭 RegisterRouter: Logout button tapped. Navigating back to Login.")
        do {
            try FirebaseManager.shared.signOut()
            
            // After logout, navigate back to the login screen
            let loginModule = LoginRouter.createModule()
            let navigationController = UINavigationController(rootViewController: loginModule)
            
            // Replace the root view controller with the login screen
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navigationController
                UIView.transition(with: window,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: nil)
            }
        } catch {
            // Show error using UIAlertController
            let alert = UIAlertController(title: "Erro ao Sair", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController?.present(alert, animated: true)
        }
    }
}

