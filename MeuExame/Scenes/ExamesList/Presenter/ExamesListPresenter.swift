import Foundation

/// ExamesListPresenter é o Presenter da tela de listagem de exames.
/// Segue o padrão VIPER, mediando a comunicação entre View, Interactor e Router.
final class ExamesListPresenter {
    
    // MARK: - VIPER Properties (Base Protocols)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Private Properties
    
    private var allExames: [ExameModel] = []
    private var filteredExames: [ExameModel] = []
    private var isSearching: Bool = false
    
    // MARK: - Private Helpers
    
    private var examesListView: ExamesListViewProtocol? {
        return view as? ExamesListViewProtocol
    }
    
    private var examesListInteractor: ExamesListInteractorProtocol? {
        return interactor as? ExamesListInteractorProtocol
    }
    
    private var examesListRouter: ExamesListRouterProtocol? {
        return router as? ExamesListRouterProtocol
    }
}

// MARK: - PresenterProtocol

extension ExamesListPresenter: PresenterProtocol {
    func viewDidLoad() {
        print("📋 ExamesListPresenter: View carregada, buscando exames...")
        view?.showLoading()
        examesListInteractor?.fetchExames()
    }
    
    func viewWillAppear() {
        print("📋 ExamesListPresenter: View irá aparecer, atualizando dados...")
        examesListInteractor?.fetchExames()
    }
}

// MARK: - ExamesListPresenterProtocol

extension ExamesListPresenter: ExamesListPresenterProtocol {
    func didSelectExam(_ exam: ExameModel) {
        print("📋 ExamesListPresenter: Exame selecionado: \(exam.nome)")
        examesListRouter?.navigateToExamDetail(exam)
    }
    
    func didTapAddExam() {
        print("📋 ExamesListPresenter: Navegar para adicionar exame")
        examesListRouter?.navigateToAddExam()
    }
    
    func didPullToRefresh() {
        print("📋 ExamesListPresenter: Pull to refresh")
        examesListInteractor?.fetchExames()
    }
    
    func didSearch(with searchText: String) {
        print("📋 ExamesListPresenter: Buscar com texto: \(searchText)")
        
        guard !searchText.isEmpty else {
            didCancelSearch()
            return
        }
        
        isSearching = true
        examesListInteractor?.searchExames(with: searchText)
    }
    
    func didCancelSearch() {
        print("📋 ExamesListPresenter: Cancelar busca")
        isSearching = false
        
        if allExames.isEmpty {
            examesListView?.showEmptyState("Nenhum exame cadastrado")
        } else {
            examesListView?.hideEmptyState()
            examesListView?.updateExames(allExames)
        }
    }
    
    func didTapFilter() {
        print("📋 ExamesListPresenter: Filtrar exames")
        examesListRouter?.navigateToFilter()
    }
}

// MARK: - ExamesListInteractorOutputProtocol

extension ExamesListPresenter: ExamesListInteractorOutputProtocol {
    func examesDidLoad(_ exams: [ExameModel]) {
        print("📋 ExamesListPresenter: \(exams.count) exames carregados")
        view?.hideLoading()
        
        allExames = exams
        
        if exams.isEmpty {
            examesListView?.showEmptyState("Nenhum exame cadastrado")
        } else {
            examesListView?.hideEmptyState()
            examesListView?.updateExames(exams)
        }
    }
    
    func examesDidFail(error: Error) {
        print("❌ ExamesListPresenter: Erro ao carregar exames: \(error.localizedDescription)")
        view?.hideLoading()
        view?.showError(
            title: "Erro ao Carregar",
            message: "Não foi possível carregar os exames. Tente novamente."
        )
    }
    
    func searchResultsDidLoad(_ exams: [ExameModel]) {
        print("📋 ExamesListPresenter: \(exams.count) resultados de busca")
        filteredExames = exams
        
        if exams.isEmpty {
            examesListView?.showEmptyState("Nenhum exame encontrado")
        } else {
            examesListView?.hideEmptyState()
            examesListView?.updateSearchResults(exams)
        }
    }
    
    func exameDidDelete(_ exam: ExameModel) {
        print("✅ ExamesListPresenter: Exame deletado: \(exam.nome)")
        
        // Remove from local cache
        allExames.removeAll { $0.id == exam.id }
        
        view?.showSuccess(
            title: "Sucesso",
            message: "Exame excluído com sucesso."
        )
        
        // Reload data
        examesListInteractor?.fetchExames()
    }
    
    func exameDeleteDidFail(error: Error) {
        print("❌ ExamesListPresenter: Erro ao deletar exame: \(error.localizedDescription)")
        view?.showError(
            title: "Erro ao Excluir",
            message: "Não foi possível excluir o exame. Tente novamente."
        )
    }
}

