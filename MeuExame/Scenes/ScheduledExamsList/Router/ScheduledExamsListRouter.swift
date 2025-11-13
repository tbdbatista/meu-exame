import UIKit

/// ScheduledExamsListRouter é o Router da tela de listagem de exames agendados.
/// Segue o padrão VIPER, gerenciando navegação e montagem do módulo.
final class ScheduledExamsListRouter {
    
    // MARK: - VIPER Property
    
    weak var viewController: UIViewController?
}

// MARK: - RouterProtocol

extension ScheduledExamsListRouter: RouterProtocol {
    // Base protocol conformance
}

// MARK: - ScheduledExamsListRouterProtocol

extension ScheduledExamsListRouter: ScheduledExamsListRouterProtocol {
    func navigateToExamDetail(_ exam: ExameModel) {
        print("🧭 ScheduledExamsListRouter: Navegar para detalhes do exame: \(exam.nome)")
        
        let detailViewController = ExameDetailRouter.createModule(with: exam)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - Module Creation

extension ScheduledExamsListRouter {
    /// Creates and assembles the ScheduledExamsList module with all VIPER components
    /// - Returns: Configured ScheduledExamsListViewController
    static func createModule() -> UIViewController {
        print("🏗️ ScheduledExamsListRouter: Criando módulo ScheduledExamsList")
        
        // Create service
        let exameService = DependencyContainer.shared.makeExamesService()
        
        // Create components
        let view = ScheduledExamsListViewController()
        let presenter = ScheduledExamsListPresenter()
        let interactor = ScheduledExamsListInteractor(exameService: exameService)
        let router = ScheduledExamsListRouter()
        
        // Connect VIPER components
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.output = presenter
        
        router.viewController = view
        
        print("✅ ScheduledExamsListRouter: Módulo criado com sucesso")
        return view
    }
}

