import UIKit

/// HomeRouter handles navigation and module assembly for the Home scene.
/// It is responsible for creating all VIPER components and injecting their dependencies.
final class HomeRouter {
    
    // MARK: - VIPER Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Static Module Creation
    
    /// Creates and configures the Home VIPER module.
    /// - Returns: The entry point `UIViewController` for the Home module.
    static func createModule() -> UIViewController {
        print("🏗️ HomeRouter: Creating Home module")
        
        // Get services
        let exameService = DependencyContainer.shared.makeExamesService()
        
        // Create VIPER components
        let view = HomeViewController()
        let presenter = HomePresenter()
        let interactor = HomeInteractor(exameService: exameService)
        let router = HomeRouter()
        
        // Connect VIPER components (Dependency Injection)
        
        // View
        view.presenter = presenter
        view.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        // Interactor
        interactor.presenter = presenter
        interactor.output = presenter // Set output for callbacks
        
        // Router
        router.viewController = view
        
        print("✅ HomeRouter: Module created and configured")
        
        return view
    }
}

// MARK: - HomeRouterProtocol

extension HomeRouter: HomeRouterProtocol {
    func navigateToAddExam() {
        print("🧭 HomeRouter: Navigating to Add Exam")
        
        // TODO: Navigate to Add Exam screen (será implementado)
        let alert = UIAlertController(
            title: "Cadastrar Exame",
            message: "A tela de cadastro de exames será implementada em breve.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    func navigateToAbout() {
        print("🧭 HomeRouter: Navigating to About")
        
        // Create About screen (simple)
        let aboutVC = UIViewController()
        aboutVC.view.backgroundColor = .systemBackground
        aboutVC.title = "Sobre o App"
        
        let textView = UITextView()
        textView.text = """
        📋 MeuExame
        
        Versão: 1.0.0
        
        Gerenciador de Exames Médicos
        
        Este aplicativo permite que você:
        • Cadastre seus exames médicos
        • Organize por data e tipo
        • Anexe arquivos e fotos
        • Acompanhe seu histórico médico
        
        Desenvolvido com:
        • Swift + UIKit
        • VIPER Architecture
        • Firebase (Auth, Firestore, Storage)
        • 100% View Code
        
        © 2025 MeuExame. Todos os direitos reservados.
        """
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        aboutVC.view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: aboutVC.view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: aboutVC.view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: aboutVC.view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: aboutVC.view.bottomAnchor)
        ])
        
        let navController = UINavigationController(rootViewController: aboutVC)
        viewController?.present(navController, animated: true)
    }
    
    func navigateToUserProfile() {
        print("🧭 HomeRouter: Navigating to User Profile")
        
        let profileVC = ProfileRouter.createModule()
        let navController = UINavigationController(rootViewController: profileVC)
        navController.modalPresentationStyle = .fullScreen
        viewController?.present(navController, animated: true)
    }
    
    func navigateToExamList() {
        print("🧭 HomeRouter: Navigating to Exam List")
        
        // Já está no TabBar, apenas switch tab
        if let tabBarController = viewController?.tabBarController {
            tabBarController.selectedIndex = 1 // Exam List tab
        }
    }
}

