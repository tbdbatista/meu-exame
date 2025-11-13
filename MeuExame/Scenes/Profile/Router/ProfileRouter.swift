import UIKit

/// ProfileRouter handles navigation from the Profile scene
final class ProfileRouter {
    
    // MARK: - VIPER Properties
    
    weak var viewController: UIViewController?
}

// MARK: - ProfileRouterProtocol

extension ProfileRouter: ProfileRouterProtocol {
    func showChangePasswordScreen() {
        // Password change is handled via alert in ViewController
        print("🔑 ProfileRouter: showChangePasswordScreen (handled by View)")
    }
    
    func dismiss() {
        print("❌ ProfileRouter: dismiss")
        viewController?.dismiss(animated: true)
    }
    
    func showLoginScreen() {
        print("🔄 ProfileRouter: showLoginScreen")
        
        // Navigate to login by resetting window root
        guard let window = viewController?.view.window else {
            print("⚠️ ProfileRouter: No window found")
            return
        }
        
        let loginVC = LoginRouter.createModule()
        let navController = UINavigationController(rootViewController: loginVC)
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

// MARK: - RouterProtocol

extension ProfileRouter: RouterProtocol {
    static func createModule() -> UIViewController {
        let userService = DependencyContainer.shared.makeUserService()
        let storageService = FirebaseManager.shared // Implements StorageServiceProtocol
        
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(userService: userService, storageService: storageService)
        let router = ProfileRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.output = presenter
        
        router.viewController = view
        
        return view
    }
}

