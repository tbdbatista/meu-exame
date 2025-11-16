import UIKit

/// ExameDetailRouter é o Router da tela de detalhes do exame.
/// Segue o padrão VIPER, gerenciando navegação e montagem do módulo.
final class ExameDetailRouter {
    
    // MARK: - VIPER Property
    
    weak var viewController: UIViewController?
}

// MARK: - RouterProtocol

extension ExameDetailRouter: RouterProtocol {
    // Base protocol conformance
    static func createModule() -> UIViewController {
        // This should not be called directly for ExameDetail
        // Use createModule(with:) instead
        fatalError("Use ExameDetailRouter.createModule(with:) instead")
    }
}

// MARK: - ExameDetailRouterProtocol

extension ExameDetailRouter: ExameDetailRouterProtocol {
    func dismiss() {
        print("🧭 ExameDetailRouter: Dismissing detail screen")
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showDeleteConfirmation(onConfirm: @escaping () -> Void) {
        print("🧭 ExameDetailRouter: Showing delete confirmation")
        
        let alert = UIAlertController(
            title: "Excluir Exame",
            message: "Tem certeza que deseja excluir este exame? Esta ação não pode ser desfeita.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Excluir", style: .destructive) { _ in
            onConfirm()
        })
        
        viewController?.present(alert, animated: true)
    }
    
    func showFileViewer(fileURL: URL, fileName: String? = nil) {
        print("🧭 ExameDetailRouter: Showing file viewer for: \(fileURL)")
        
        // Extract file name from URL if not provided
        let fileDisplayName = fileName ?? fileURL.lastPathComponent
        
        // Get storage service from FirebaseManager
        let storageService = FirebaseManager.shared as? StorageServiceProtocol
        
        // Create and present file viewer
        let fileViewer = FileViewerViewController(
            fileURL: fileURL,
            fileName: fileDisplayName,
            storageService: storageService
        )
        
        let navController = UINavigationController(rootViewController: fileViewer)
        navController.modalPresentationStyle = .fullScreen
        
        viewController?.present(navController, animated: true)
    }
    
    func showShareSheet(items: [Any]) {
        print("🧭 ExameDetailRouter: Showing share sheet")
        
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController?.view
            popover.sourceRect = CGRect(
                x: viewController?.view.bounds.midX ?? 0,
                y: viewController?.view.bounds.midY ?? 0,
                width: 0,
                height: 0
            )
        }
        
        viewController?.present(activityVC, animated: true)
    }
}

// MARK: - Module Creation

extension ExameDetailRouter {
    /// Creates and assembles the ExameDetail module with all VIPER components
    /// - Parameter exame: The exam to display
    /// - Returns: Configured ExameDetailViewController
    static func createModule(with exame: ExameModel) -> UIViewController {
        print("🏗️ ExameDetailRouter: Criando módulo ExameDetail para: \(exame.nome)")
        
        // Get services from DependencyContainer
        let exameService = DependencyContainer.shared.makeExamesService()
        let storageService = FirebaseManager.shared // implements StorageServiceProtocol
        let notificationService = DependencyContainer.shared.makeNotificationService()
        
        // Create components
        let view = ExameDetailViewController()
        let presenter = ExameDetailPresenter()
        let interactor = ExameDetailInteractor(exameService: exameService, storageService: storageService, notificationService: notificationService)
        let router = ExameDetailRouter()
        
        // Configure presenter with exam
        presenter.configure(with: exame)
        
        // Connect VIPER components
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.output = presenter
        
        router.viewController = view
        
        print("✅ ExameDetailRouter: Módulo criado com sucesso")
        return view
    }
}

