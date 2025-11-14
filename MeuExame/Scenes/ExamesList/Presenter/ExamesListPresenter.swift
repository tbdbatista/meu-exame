import Foundation

/// Filter options for exams
enum ExamFilter: String, CaseIterable {
    case all = "Todos"
    case agendado = "Agendados"
    case realizado = "Realizados"
    case resultadoPendente = "Resultado Pendente"
}

/// Sort options for exams
enum ExamSort: String, CaseIterable {
    case nameAscending = "Nome (A-Z)"
    case nameDescending = "Nome (Z-A)"
    case dateAscending = "Data (Mais Antigo)"
    case dateDescending = "Data (Mais Recente)"
}

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
    private var currentFilter: ExamFilter = .all
    private var currentSort: ExamSort = .dateDescending
    
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
        applyFiltersAndSort()
    }
    
    func applyFilter(_ filter: ExamFilter) {
        currentFilter = filter
        applyFiltersAndSort()
    }
    
    func applySort(_ sort: ExamSort) {
        currentSort = sort
        applyFiltersAndSort()
    }
    
    private func applyFiltersAndSort() {
        var result = allExames
        
        // Apply filter
        switch currentFilter {
        case .all:
            break // No filter
        case .agendado:
            result = result.filter { $0.isAgendado }
        case .realizado:
            result = result.filter { $0.isRealizado }
        case .resultadoPendente:
            result = result.filter { $0.isResultadoPendente }
        }
        
        // Apply sort
        switch currentSort {
        case .nameAscending:
            result.sort { $0.nome.localizedCaseInsensitiveCompare($1.nome) == .orderedAscending }
        case .nameDescending:
            result.sort { $0.nome.localizedCaseInsensitiveCompare($1.nome) == .orderedDescending }
        case .dateAscending:
            result.sort { $0.dataCadastro < $1.dataCadastro }
        case .dateDescending:
            result.sort { $0.dataCadastro > $1.dataCadastro }
        }
        
        if result.isEmpty {
            let message = currentFilter == .all ? "Nenhum exame cadastrado" : "Nenhum exame encontrado com o filtro selecionado"
            examesListView?.showEmptyState(message)
        } else {
            examesListView?.hideEmptyState()
            examesListView?.updateExames(result)
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
        applyFiltersAndSort()
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

