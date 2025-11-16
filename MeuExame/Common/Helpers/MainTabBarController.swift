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
        // Placeholder VC to hold the tab position
        let addExamPlaceholder = UIViewController()
        addExamPlaceholder.tabBarItem = UITabBarItem(
            title: "Cadastrar",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        
        // Set view controllers
        viewControllers = [homeVC, examListNavController, addExamPlaceholder]
        
        // Set delegate to intercept tab selection
        delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Creates and returns a configured MainTabBarController
    static func create() -> MainTabBarController {
        print("🏗️ MainTabBarController: Creating main navigation")
        let tabBar = MainTabBarController()
        return tabBar
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Check if it's the Add Exam tab (index 2)
        guard let viewControllers = tabBarController.viewControllers,
              let index = viewControllers.firstIndex(of: viewController),
              index == 2 else {
            return true
        }
        
        // Present Add Exam modal
        print("📝 MainTabBarController: Presenting AddExam modal")
        let addExamModule = AddExamRouter.createModule()
        present(addExamModule, animated: true)
        
        // Don't actually select the tab
        return false
    }
}

