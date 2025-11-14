import UIKit

/// AddExamRouter é o Router da tela de cadastro de exames.
/// Segue o padrão VIPER, gerenciando navegação e montagem do módulo.
final class AddExamRouter {
    
    // MARK: - VIPER Property
    
    weak var viewController: UIViewController?
}

// MARK: - RouterProtocol

extension AddExamRouter: RouterProtocol {
    // Base protocol conformance
}

// MARK: - AddExamRouterProtocol

extension AddExamRouter: AddExamRouterProtocol {
    func dismiss() {
        print("🧭 AddExamRouter: Dismissing add exam screen")
        viewController?.dismiss(animated: true)
    }
    
    func showFilePicker() {
        print("🧭 AddExamRouter: Showing file picker")
        
        let documentPicker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.pdf, .image, .jpeg, .png],
            asCopy: true
        )
        
        if let vc = viewController as? AddExamViewController {
            documentPicker.delegate = vc
            documentPicker.allowsMultipleSelection = false
            vc.present(documentPicker, animated: true)
        }
    }
}

// MARK: - Module Creation

extension AddExamRouter {
    /// Creates and assembles the AddExam module with all VIPER components
    /// - Returns: Configured AddExamViewController wrapped in UINavigationController
    static func createModule() -> UIViewController {
        print("🏗️ AddExamRouter: Criando módulo AddExam")
        
        // Get services
        let exameService = DependencyContainer.shared.makeExamesService()
        let storageService = FirebaseManager.shared // implements StorageServiceProtocol
        let notificationService = DependencyContainer.shared.makeNotificationService()
        
        // Create components
        let view = AddExamViewController()
        let presenter = AddExamPresenter()
        let interactor = AddExamInteractor(exameService: exameService, storageService: storageService, notificationService: notificationService)
        let router = AddExamRouter()
        
        // Connect VIPER components
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.output = presenter
        
        router.viewController = view
        
        // Wrap in navigation controller
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .formSheet
        
        print("✅ AddExamRouter: Módulo criado com sucesso")
        return navigationController
    }
}

