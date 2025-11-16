import Foundation

/// ScheduledExamsListPresenter é o Presenter da tela de listagem de exames agendados.
/// Segue o padrão VIPER, mediando a comunicação entre View, Interactor e Router.
final class ScheduledExamsListPresenter {
    
    // MARK: - VIPER Properties (Base Protocols)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Private Helpers
    
    private var scheduledExamsListView: ScheduledExamsListViewProtocol? {
        return view as? ScheduledExamsListViewProtocol
    }
    
    private var scheduledExamsListInteractor: ScheduledExamsListInteractorProtocol? {
        return interactor as? ScheduledExamsListInteractorProtocol
    }
    
    private var scheduledExamsListRouter: ScheduledExamsListRouterProtocol? {
        return router as? ScheduledExamsListRouterProtocol
    }
}

// MARK: - PresenterProtocol

extension ScheduledExamsListPresenter: PresenterProtocol {
    func viewDidLoad() {
        print("📅 ScheduledExamsListPresenter: View carregada, buscando exames agendados...")
        view?.showLoading()
        scheduledExamsListInteractor?.fetchScheduledExams()
    }
    
    func viewWillAppear() {
        print("📅 ScheduledExamsListPresenter: View irá aparecer, atualizando dados...")
        scheduledExamsListInteractor?.fetchScheduledExams()
    }
}

// MARK: - ScheduledExamsListPresenterProtocol

extension ScheduledExamsListPresenter: ScheduledExamsListPresenterProtocol {
    func didSelectExam(_ exam: ExameModel) {
        print("📅 ScheduledExamsListPresenter: Exame selecionado: \(exam.nome)")
        scheduledExamsListRouter?.navigateToExamDetail(exam)
    }
    
    func didPullToRefresh() {
        print("📅 ScheduledExamsListPresenter: Pull to refresh")
        scheduledExamsListInteractor?.fetchScheduledExams()
    }
}

// MARK: - ScheduledExamsListInteractorOutputProtocol

extension ScheduledExamsListPresenter: ScheduledExamsListInteractorOutputProtocol {
    func scheduledExamsDidLoad(_ exams: [ExameModel]) {
        print("📅 ScheduledExamsListPresenter: \(exams.count) exames agendados carregados")
        view?.hideLoading()
        
        if exams.isEmpty {
            scheduledExamsListView?.showEmptyState("Nenhum exame agendado")
        } else {
            scheduledExamsListView?.hideEmptyState()
            scheduledExamsListView?.updateScheduledExams(exams)
        }
    }
    
    func scheduledExamsDidFail(error: Error) {
        print("❌ ScheduledExamsListPresenter: Erro ao carregar exames agendados: \(error.localizedDescription)")
        view?.hideLoading()
        view?.showError(
            title: "Erro ao Carregar",
            message: "Não foi possível carregar os exames agendados. Tente novamente."
        )
    }
}

