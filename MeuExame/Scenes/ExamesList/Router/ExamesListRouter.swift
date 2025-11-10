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
        
        // TODO: Criar módulo ExamDetail quando for implementado
        // let detailViewController = ExamDetailRouter.createModule(exam: exam)
        // viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        
        // Placeholder por enquanto
        let alert = UIAlertController(
            title: "Detalhes do Exame",
            message: """
            Nome: \(exam.nome)
            Local: \(exam.localRealizado)
            Médico: \(exam.medicoSolicitante)
            Data: \(exam.dataFormatada)
            
            A tela de detalhes será implementada em breve.
            """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
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
        print("🧭 ExamesListRouter: Navegar para filtros")
        
        // TODO: Criar tela de filtros quando necessário
        let alert = UIAlertController(
            title: "Filtros",
            message: "A funcionalidade de filtros será implementada em breve.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
}

// MARK: - Module Creation

extension ExamesListRouter {
    /// Creates and assembles the ExamesList module with all VIPER components
    /// - Returns: Configured ExamesListViewController
    static func createModule() -> UIViewController {
        print("🏗️ ExamesListRouter: Criando módulo ExamesList")
        
        // Create components
        let view = ExamesListViewController()
        let presenter = ExamesListPresenter()
        let interactor = ExamesListInteractor()
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

