import Foundation

/// HomePresenter handles the presentation logic for the Home screen.
/// It acts as the middleman between the View and the Interactor,
/// formatting data for display and delegating business logic.
final class HomePresenter {
    
    // MARK: - VIPER Properties (PresenterProtocol conformance)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Initializer
    
    init() {}
    
    // MARK: - Private Helpers
    
    private var homeView: HomeViewProtocol? {
        return view as? HomeViewProtocol
    }
    
    private var homeInteractor: HomeInteractorProtocol? {
        return interactor as? HomeInteractorProtocol
    }
    
    private var homeRouter: HomeRouterProtocol? {
        return router as? HomeRouterProtocol
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {
    func viewDidLoad() {
        print("📱 HomePresenter: View did load")
        // Request data from interactor
        homeView?.showLoading()
        homeInteractor?.fetchExamSummary()
        homeInteractor?.fetchUserProfile()
        homeInteractor?.fetchScheduledExams()
    }
    
    func viewWillAppear() {
        print("📱 HomePresenter: View will appear")
        // Refresh data when view appears
        homeInteractor?.fetchExamSummary()
        homeInteractor?.fetchScheduledExams()
    }
    
    func viewDidDisappear() {
        // Cleanup if needed
    }
    
    func didTapAddExam() {
        print("📱 HomePresenter: Add exam tapped")
        homeRouter?.navigateToAddExam()
    }
    
    func didTapAbout() {
        print("📱 HomePresenter: About tapped")
        homeRouter?.navigateToAbout()
    }
    
    func didTapProfile() {
        print("📱 HomePresenter: Profile tapped")
        homeRouter?.navigateToUserProfile()
    }
    
    func didRequestRefresh() {
        print("📱 HomePresenter: Refresh requested")
        homeView?.showLoading()
        homeInteractor?.fetchExamSummary()
        homeInteractor?.fetchUserProfile()
        homeInteractor?.fetchScheduledExams()
    }
}

// MARK: - HomeInteractorOutputProtocol

extension HomePresenter: HomeInteractorOutputProtocol {
    func examSummaryDidLoad(_ summary: ExamSummary) {
        print("✅ HomePresenter: Exam summary loaded - Total: \(summary.totalExams)")
        homeView?.hideLoading()
        homeView?.updateExamSummary(summary)
    }
    
    func examSummaryDidFail(error: Error) {
        print("❌ HomePresenter: Exam summary failed - \(error.localizedDescription)")
        homeView?.hideLoading()
        homeView?.showError(
            title: "Erro ao Carregar Dados",
            message: "Não foi possível carregar o resumo de exames. \(error.localizedDescription)"
        )
    }
    
    func userProfileDidLoad(_ profile: UserProfile) {
        print("✅ HomePresenter: User profile loaded - \(profile.displayName)")
        homeView?.updateUserProfile(profile)
    }
    
    func userProfileDidFail(error: Error) {
        print("❌ HomePresenter: User profile failed - \(error.localizedDescription)")
        // Não mostra erro para profile, apenas usa dados padrão
        // A view já tem valores default
    }
    
    func scheduledExamsDidLoad(_ exams: [ExameModel]) {
        print("✅ HomePresenter: Scheduled exams loaded - \(exams.count) exams")
        homeView?.updateScheduledExams(exams)
    }
    
    func scheduledExamsDidFail(error: Error) {
        print("❌ HomePresenter: Scheduled exams failed - \(error.localizedDescription)")
        // Don't show error, just show empty list
        homeView?.updateScheduledExams([])
    }
}

