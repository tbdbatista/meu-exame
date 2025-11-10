import UIKit

/// MainTabBarController manages the main navigation structure of the app.
/// Provides tabs for Home, Exam List, and Add Exam.
final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        // Configure tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func setupViewControllers() {
        // 1. Home Tab
        let homeVC = HomeRouter.createModule()
        
        // 2. Exam List Tab
        let examListVC = ExamesListRouter.createModule()
        let examListNavController = UINavigationController(rootViewController: examListVC)
        examListNavController.tabBarItem = UITabBarItem(
            title: "Exames",
            image: UIImage(systemName: "list.bullet.clipboard"),
            selectedImage: UIImage(systemName: "list.bullet.clipboard.fill")
        )
        
        // 3. Add Exam Tab (middle button, larger)
        let addExamVC = createAddExamPlaceholder()
        addExamVC.tabBarItem = UITabBarItem(
            title: "Cadastrar",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        
        // Set view controllers
        viewControllers = [homeVC, examListNavController, addExamVC]
    }
    
    // MARK: - Placeholder ViewControllers
    
    private func createAddExamPlaceholder() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "➕ Cadastrar Exame\n\n(Será implementado em breve)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        ])
        
        return vc
    }
    
    // MARK: - Public Methods
    
    /// Creates and returns a configured MainTabBarController
    static func create() -> MainTabBarController {
        print("🏗️ MainTabBarController: Creating main navigation")
        let tabBar = MainTabBarController()
        return tabBar
    }
}

