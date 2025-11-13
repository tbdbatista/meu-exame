import UIKit

/// ExamesListRouter é o Router da tela de listagem de exames.
/// Segue o padrão VIPER, gerenciando navegação e montagem do módulo.
final class ExamesListRouter {
    
    // MARK: - VIPER Property
    
    weak var viewController: UIViewController?
}

// MARK: - RouterProtocol

extension ExamesListRouter: RouterProtocol {
    // Base protocol conformance
}

// MARK: - ExamesListRouterProtocol

extension ExamesListRouter: ExamesListRouterProtocol {
    func navigateToExamDetail(_ exam: ExameModel) {
        print("🧭 ExamesListRouter: Navegar para detalhes do exame: \(exam.nome)")
        
        let detailViewController = ExameDetailRouter.createModule(with: exam)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func navigateToAddExam() {
        print("🧭 ExamesListRouter: Navegar para adicionar exame")
        
        // TODO: Criar módulo AddExam quando for implementado
        // let addExamViewController = AddExamRouter.createModule()
        // let navController = UINavigationController(rootViewController: addExamViewController)
        // viewController?.present(navController, animated: true)
        
        // Placeholder por enquanto
        let alert = UIAlertController(
            title: "Cadastrar Exame",
            message: "A tela de cadastro de exames será implementada em breve.\n\nPor enquanto, use a tab 'Cadastrar' na barra inferior.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    func navigateToFilter() {
        print("🧭 ExamesListRouter: Mostrar opções de filtro e ordenação")
        
        guard let viewController = viewController,
              let presenter = viewController as? ExamesListViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "Filtros e Ordenação",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // Filter options
        alert.addAction(UIAlertAction(title: "Filtros", style: .default) { _ in
            presenter.showFilterOptions()
        })
        
        // Sort options
        alert.addAction(UIAlertAction(title: "Ordenar", style: .default) { _ in
            presenter.showSortOptions()
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = viewController.navigationItem.leftBarButtonItem
        }
        
        viewController.present(alert, animated: true)
    }
}

// MARK: - Module Creation

extension ExamesListRouter {
    /// Creates and assembles the ExamesList module with all VIPER components
    /// - Returns: Configured ExamesListViewController
    static func createModule() -> UIViewController {
        print("🏗️ ExamesListRouter: Criando módulo ExamesList")
        
        // Create service
        let exameService = FirestoreExamesService()
        
        // Create components
        let view = ExamesListViewController()
        let presenter = ExamesListPresenter()
        let interactor = ExamesListInteractor(exameService: exameService)
        let router = ExamesListRouter()
        
        // Connect VIPER components
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.output = presenter
        
        router.viewController = view
        
        print("✅ ExamesListRouter: Módulo criado com sucesso")
        return view
    }
}

